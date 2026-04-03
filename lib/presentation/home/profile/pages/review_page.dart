// lib/presentation/home/profile/pages/review_page.dart
// ✨ COMPLETE FIXED VERSION - Ready to use!

import 'package:flutter/material.dart';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/managers/reviews_manager.dart';
import 'package:intl/intl.dart';

/// Available places for review selection
class ReviewPlaces {
  static const List<String> all = [
    'Bab Bou Jeloud',
    'Al-Qarawiyyin Mosque',
    'Bou Inania Madrasa',
    'Chouara Tannery',
    'Dar Batha Museum',
    'Nejjarine Museum',
    'Borj Nord',
    'Royal Palace',
    'Other',
  ];
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> with SingleTickerProviderStateMixin {
  final ReviewsManager _reviewsManager = ReviewsManager();
  late TabController _tabController;

  // Cache filtered reviews to avoid redundant filtering
  Map<int, List<Map<String, dynamic>>> _cachedReviewsByRating = {};
  bool _cacheValid = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _reviewsManager.addListener(_onReviewsChanged);
    _loadReviews();
  }

  @override
  void dispose() {
    _reviewsManager.removeListener(_onReviewsChanged);
    _tabController.dispose();
    super.dispose();
  }

  /// Load reviews from storage
  Future<void> _loadReviews() async {
    try {
      await _reviewsManager.loadReviews();
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to load reviews: $e');
      }
    }
  }

  /// Handle reviews change and invalidate cache
  void _onReviewsChanged() {
    if (mounted) {
      setState(() {
        _cacheValid = false;
      });
    }
  }

  /// Get reviews by rating with caching
  List<Map<String, dynamic>> _getReviewsByRating(int rating) {
    if (!_cacheValid) {
      _rebuildCache();
    }
    return _cachedReviewsByRating[rating] ?? [];
  }

  /// Rebuild the cache of filtered reviews
  void _rebuildCache() {
    _cachedReviewsByRating = {
      for (int i = 1; i <= 5; i++)
        i: _reviewsManager.reviews
            .where((r) => (r['rating'] as num).toInt() == i)
            .toList(),
    };
    _cacheValid = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allReviews = _reviewsManager.reviews;
    final averageRating = _reviewsManager.averageRating;

    // Loading state
    if (_reviewsManager.isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(context, l10n, false),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF9800),
            semanticsLabel: 'Loading reviews',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, l10n, allReviews.isNotEmpty),
      body: allReviews.isEmpty
          ? _buildEmptyState(l10n)
          : Column(
        children: [
          _buildHeaderSection(allReviews, averageRating),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReviewsList(allReviews),
                _buildReviewsList(_getReviewsByRating(5)),
                _buildReviewsList(_getReviewsByRating(4)),
                _buildReviewsList(_getReviewsByRating(3)),
                _buildReviewsList(_getReviewsByRating(2)),
                _buildReviewsList(_getReviewsByRating(1)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReviewDialog(),
        backgroundColor: const Color(0xFFFF9800),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Review',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        tooltip: 'Add a new review',
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context,
      AppLocalizations l10n,
      bool hasReviews,
      ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Go back',
      ),
      title: Text(
        l10n.leaveReview,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
      actions: hasReviews
          ? [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          tooltip: 'More options',
          onSelected: (value) {
            if (value == 'clear') {
              _showClearAllDialog();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Clear All Reviews'),
                ],
              ),
            ),
          ],
        ),
      ]
          : null,
    );
  }

  Widget _buildHeaderSection(
      List<Map<String, dynamic>> allReviews,
      double averageRating,
      ) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    label: 'Total',
                    value: allReviews.length.toString(),
                    icon: Icons.rate_review,
                    color: const Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    label: 'Average',
                    value: averageRating.toStringAsFixed(1),
                    icon: Icons.star,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: const Color(0xFFFF9800),
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: const Color(0xFFFF9800),
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'All (${allReviews.length})', height: 48),
              Tab(text: '⭐ 5 (${_getReviewsByRating(5).length})', height: 48),
              Tab(text: '⭐ 4 (${_getReviewsByRating(4).length})', height: 48),
              Tab(text: '⭐ 3 (${_getReviewsByRating(3).length})', height: 48),
              Tab(text: '⭐ 2 (${_getReviewsByRating(2).length})', height: 48),
              Tab(text: '⭐ 1 (${_getReviewsByRating(1).length})', height: 48),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Semantics(
      label: '$label: $value',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.rate_review_outlined,
                size: 60,
                color: const Color(0xFFFF9800).withOpacity(0.5),
                semanticLabel: 'No reviews',
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No Reviews Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Share your experiences and help\nother travelers discover Fes!',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _showAddReviewDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'Write Your First Review',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList(List<Map<String, dynamic>> reviews) {
    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[300],
              semanticLabel: 'No reviews found',
            ),
            const SizedBox(height: 16),
            Text(
              'No reviews in this category',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _buildReviewCard(review);
      },
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final date = review['date'] as DateTime;
    final rating = (review['rating'] as num).toDouble();
    final placeName = review['placeName'] ?? 'Unknown Place';
    final comment = review['comment'] ?? '';
    final updatedAt = review['updatedAt'] as DateTime?;
    final isEdited = updatedAt != null && updatedAt.isAfter(date);

    return Semantics(
      label: 'Review for $placeName, rating ${rating.toInt()} out of 5 stars',
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          placeName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < rating ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                                semanticLabel: index < rating ? 'Filled star' : 'Empty star',
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                    tooltip: 'Review options',
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditReviewDialog(review);
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(review['id'], placeName);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (comment.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  comment,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy').format(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (isEdited) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Edited',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddReviewDialog() {
    double rating = 5;
    String selectedPlace = ReviewPlaces.all.first;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Add Review',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Place',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: selectedPlace,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: ReviewPlaces.all.map((place) {
                      return DropdownMenuItem(
                        value: place,
                        child: Text(place),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPlace = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setDialogState(() {
                          rating = (index + 1).toDouble();
                        });
                      },
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        size: 36,
                        color: Colors.amber,
                      ),
                      tooltip: '${index + 1} star${index == 0 ? '' : 's'}',
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your Review',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: 'Share your experience...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF9800),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final review = {
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'placeName': selectedPlace,
                  'rating': rating,
                  'comment': commentController.text.trim(),
                  'date': DateTime.now(),
                };

                try {
                  await _reviewsManager.addReview(review);
                  if (mounted) {
                    Navigator.pop(context);
                    _showSuccessSnackBar('Review added successfully!');
                  }
                } catch (e) {
                  if (mounted) {
                    _showErrorSnackBar('Failed to add review: $e');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditReviewDialog(Map<String, dynamic> review) {
    double rating = (review['rating'] as num).toDouble();
    String selectedPlace = review['placeName'];
    final commentController = TextEditingController(text: review['comment']);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit Review',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Place',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: selectedPlace,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: ReviewPlaces.all.map((place) {
                      return DropdownMenuItem(
                        value: place,
                        child: Text(place),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPlace = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setDialogState(() {
                          rating = (index + 1).toDouble();
                        });
                      },
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        size: 36,
                        color: Colors.amber,
                      ),
                      tooltip: '${index + 1} star${index == 0 ? '' : 's'}',
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your Review',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  maxLength: 500,
                  decoration: InputDecoration(
                    hintText: 'Share your experience...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF9800),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedReview = {
                  'placeName': selectedPlace,
                  'rating': rating,
                  'comment': commentController.text.trim(),
                };

                try {
                  await _reviewsManager.updateReview(review['id'], updatedReview);
                  if (mounted) {
                    Navigator.pop(context);
                    _showSuccessSnackBar('Review updated successfully!');
                  }
                } catch (e) {
                  if (mounted) {
                    _showErrorSnackBar('Failed to update review: $e');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String id, String placeName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Review?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete your review for "$placeName"?',
          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _reviewsManager.deleteReview(id);
                if (mounted) {
                  Navigator.pop(context);
                  _showInfoSnackBar('Removed review for "$placeName"');
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  _showErrorSnackBar('Failed to delete review: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Clear All Reviews?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete all reviews? This action cannot be undone.',
          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _reviewsManager.clearAllReviews();
                if (mounted) {
                  Navigator.pop(context);
                  _showInfoSnackBar('All reviews cleared');
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  _showErrorSnackBar('Failed to clear reviews: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  // Helper methods for snackbars
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        action: SnackBarAction(
          label: 'OK',
          textColor: const Color(0xFFFF9800),
          onPressed: () {},
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}