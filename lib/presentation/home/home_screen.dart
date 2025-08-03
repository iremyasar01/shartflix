import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shartflix/core/utils/storage_service.dart';
import 'package:shartflix/domain/entities/movie_entity.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'package:shartflix/injection_container.dart' as di;
import 'package:shartflix/presentation/common_widgets/custom_bottom_nav_bar.dart';
import 'package:shartflix/presentation/login/screens/login_screen.dart';
import 'package:shartflix/presentation/movie/bloc/movie_list_bloc.dart';
import 'package:shartflix/presentation/movie/bloc/movie_list_event.dart';
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
    
    // BLoC'u GetIt üzerinden bağımlılıklarla oluştur
    _movieListBloc = MovieListBloc(
      movieRepository: di.sl<MovieRepository>(),
      localStorage: di.sl<StorageService>(),
    )..add(FetchMovies());
    
    _loadToken();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _movieListBloc.add(LoadMoreMovies());
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
          
          return RefreshIndicator(
            onRefresh: () async => _movieListBloc.add(RefreshMovies()),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < state.movies.length) {
                        return _buildMovieItem(state.movies[index]);
                      } else if (state.isLoadMore) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                    childCount: state.movies.length + (state.isLoadMore ? 1 : 0),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieItem(Movie movie) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              movie.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: movie.isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () => _movieListBloc.add(ToggleFavorite(movie.id)),
          ),
        ],
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