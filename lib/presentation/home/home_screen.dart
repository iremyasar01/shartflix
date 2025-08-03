import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/utils/storage_service.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'package:shartflix/injection_container.dart' as di;
import 'package:shartflix/presentation/common_widgets/custom_bottom_nav_bar.dart';
import 'package:shartflix/presentation/login/screens/login_screen.dart';
import 'package:shartflix/presentation/movie/bloc/movie_list_bloc.dart';
import 'package:shartflix/presentation/movie/bloc/movie_list_event.dart';
import 'package:shartflix/presentation/movie/screens/movie_detail_screen.dart';
import 'package:shartflix/presentation/movie/widgets/movie_grid_item.dart';
import 'package:shartflix/presentation/profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userToken;
  int _selectedIndex = 0;
  final List<Widget> _pages = [];
  final ScrollController _scrollController = ScrollController();
  late MovieListBloc _movieListBloc;

  @override
  void initState() {
    super.initState();
    
    _movieListBloc = MovieListBloc(
      movieRepository: di.sl<MovieRepository>(),
      localStorage: di.sl<StorageService>(),
    )..add(FetchMovies());
    
    _loadToken();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      if (!_movieListBloc.state.isLoadMore && 
          _movieListBloc.state.currentPage < _movieListBloc.state.totalPages) {
        _movieListBloc.add(LoadMoreMovies());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _movieListBloc.close();
    super.dispose();
  }

  Future<void> _loadToken() async {
    final token = await di.sl<StorageService>().getToken();
    if (mounted) {
      setState(() {
        _userToken = token;
        _pages.addAll([
          _buildHomePageBody(),
          ProfileScreen(token: _userToken),
        ]);
      });
    }
  }

  Future<void> _logout() async {
    await di.sl<StorageService>().deleteToken();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePageBody() {
    return BlocProvider.value(
      value: _movieListBloc,
      child: BlocBuilder<MovieListBloc, MovieListState>(
        builder: (context, state) {
          if (state.isLoading && state.movies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Hata: ${state.error}'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              _movieListBloc.add(RefreshMovies());
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Başlık ve arama
                SliverAppBar(
                  title: const Text(
                    'Keşfet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search, size: 28),
                      onPressed: () {},
                    ),
                  ],
                  pinned: true,
                  floating: true,
                ),

                // Tüm filmlerin grid görünümü (sonsuz kaydırma)
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < state.movies.length) {
                          return MovieGridItem(
                            movie: state.movies[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                    initialMovie: state.movies[index],
                                    allMovies: state.movies,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return null;
                      },
                      childCount: state.movies.length + (state.isLoadMore ? 1 : 0),
                    ),
                  ),
                ),

                // Yükleniyor gösterge (sonsuz kaydırma için)
                if (state.isLoadMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text('Ana Sayfa'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ],
              automaticallyImplyLeading: false,
            )
          : null,
      
      body: _pages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
      
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}