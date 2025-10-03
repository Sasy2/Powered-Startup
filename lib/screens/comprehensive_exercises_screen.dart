import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise_models.dart';
import '../providers/exercise_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class ComprehensiveExercisesScreen extends StatefulWidget {
  const ComprehensiveExercisesScreen({super.key});

  @override
  State<ComprehensiveExercisesScreen> createState() => _ComprehensiveExercisesScreenState();
}

class _ComprehensiveExercisesScreenState extends State<ComprehensiveExercisesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // background-light
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'Exercises'),
            Expanded(
              child: Consumer<ExerciseProvider>(
                builder: (context, exerciseProvider, child) {
                  if (exerciseProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF10B2D0),
                      ),
                    );
                  }
                  
                  if (exerciseProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Color(0xFF10B2D0),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${exerciseProvider.error}',
                            style: const TextStyle(
                              color: Color(0xFF618389),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => exerciseProvider.initialize(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWeeklyTracker(),
                        const SizedBox(height: 24),
                        _buildTodaysPlan(exerciseProvider),
                        const SizedBox(height: 24),
                        _buildExerciseLibrary(exerciseProvider),
                        const SizedBox(height: 24),
                        _buildShareProgress(),
                        const SizedBox(height: 100), // Space for bottom nav
                      ],
                    ),
                  );
                },
              ),
            ),
            const AppFooter(currentIndex: 1),
          ],
        ),
      ),
    );
  }


  Widget _buildWeeklyTracker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Tracker',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718), // foreground-light
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F4), // card-light
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayTracker('Mon', true, false),
              _buildDayTracker('Tue', true, false),
              _buildDayTracker('Wed', true, false),
              _buildDayTracker('Thu', true, false),
              _buildDayTracker('Fri', false, true),
              _buildDayTracker('Sat', false, false),
              _buildDayTracker('Sun', false, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayTracker(String day, bool completed, bool isToday) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday 
                ? const Color(0xFF10B2D0) // primary
                : const Color(0xFF618389), // subtle-light
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: completed 
                ? const Color(0xFF10B2D0) // primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: completed 
                ? null
                : Border.all(
                    color: isToday 
                        ? const Color(0xFF10B2D0) // primary
                        : const Color(0xFFDBE4E6), // border-light
                    width: 2,
                  ),
          ),
          child: Center(
            child: completed
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  )
                : isToday
                    ? const Text(
                        '26',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B2D0), // primary
                        ),
                      )
                    : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysPlan(ExerciseProvider exerciseProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Plan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718), // foreground-light
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: exerciseProvider.dailySuggestions.take(3).map((exercise) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildExerciseCard(
                exercise.name,
                '${(exercise.durationSeconds / 60).round()} minutes',
                _getExerciseIcon(exercise.iconName),
                0.5, // Default progress
                false,
                exercise: exercise,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(String title, String duration, IconData icon, double progress, bool completed, {Exercise? exercise}) {
    return GestureDetector(
      onTap: () {
        if (exercise != null) {
          _startExercise(exercise);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F4), // card-light
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF10B2D0).withValues(alpha: 0.2), // primary/20
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF10B2D0), // primary
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111718), // foreground-light
                      decoration: completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF618389), // subtle-light
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (completed)
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B2D0), // primary
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
              )
            else
              _buildProgressCircle(progress),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCircle(double progress) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        children: [
          // Background circle
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFDBE4E6), // border-light
                width: 3,
              ),
            ),
          ),
          // Progress circle
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B2D0)), // primary
            ),
          ),
          // Play button
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF), // background-light
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Color(0xFF10B2D0), // primary
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseLibrary(ExerciseProvider exerciseProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Exercise Library',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111718), // foreground-light
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Search bar
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F4), // card-light
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFDBE4E6), // border-light
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                // Filter exercises based on search query
              });
            },
            decoration: const InputDecoration(
              hintText: 'Search exercises...',
              hintStyle: TextStyle(
                color: Color(0xFF618389), // subtle-light
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFF618389), // subtle-light
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Category cards
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategoryCard(
                'Eye Training',
                'Strengthen your eye muscles',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDCvGWTU7qYYlzXnENh1bchcJta3Go0crKhCqX6fR4O5WNprWXex5ajxV-tdVZK0Ul-PYa_jXvZ1Q7KDU4UNGKaRHiZRkh2W_oIv7HBmJ2COE-upstWbkTcRzRrd28HNqTkAX4rdsrttyO9wgS57hT4cuNP6hHE-dUJHjFoYmtvEgyMh1_PVcgld5VuMq-B0JnkWvx_bq8cTeb7J3ozDuRkKD5jbnOvFLx9RmXU2X8UCTPVzs55d3S8soUokFNdv3itYMydf_TGKnjZ',
                ExerciseCategory.focusTraining,
                exerciseProvider,
              ),
              const SizedBox(width: 16),
              _buildCategoryCard(
                'Relaxation',
                'Reduce eye strain',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAjUyryU5tgYc51DSi1IG3QAWa98kja5Cwr7L3PZR3t6pu1yfwv_Rd-h8PjtISehp3osuvvNp3pn29q9Oa8LhqgFo3l71FfL3M2-an5Ta4X4Gh3mp9mHiqGH5uUB_rCsuZmnAvAuOqrXKFQ3pKT3bFZVASAKX6FIwYliGOuXmqcdLLfLwWQaIL_xCDCu8Dqpnjr9nYYUjOo0_P54FTetJvxkCbXpFVVBd_CYMkUygL7AGqjkendXjMNLQH0K93w7PFKYqhpAKzSRll_',
                ExerciseCategory.relaxation,
                exerciseProvider,
              ),
              const SizedBox(width: 16),
              _buildCategoryCard(
                'Migraine Relief',
                'Exercises for headache relief',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAwDd2EAgkJNpnGy7k97bGNjMk92bcdz3NRoh3qUmPDB3FMauztk7Rrcek0wWZTRdJiJHBHZy3_Yp2KD-ZOBQLE6N31rbajjz6JIUpQ2jvhLcnuuIS17pkJomWBLvvF34ftYtcqGNKN_PvYRLzPWmGDZ7V_F4fRI-T6VPfOmLqtWiW2LjY8dzStE2Uq9dYGG75bW3MXRU2uJH8cjct7WCaAbAz7vR3CoxMnqUcpFDSq0IabizesHcBuRe0vBuNTF5CWYcYnJlADSXqT',
                ExerciseCategory.migraineRelief,
                exerciseProvider,
              ),
              const SizedBox(width: 16),
              _buildCategoryCard(
                'Screen Strain Relief',
                'For tired eyes',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAwDd2EAgkJNpnGy7k97bGNjMk92bcdz3NRoh3qUmPDB3FMauztk7Rrcek0wWZTRdJiJHBHZy3_Yp2KD-ZOBQLE6N31rbajjz6JIUpQ2jvhLcnuuIS17pkJomWBLvvF34ftYtcqGNKN_PvYRLzPWmGDZ7V_F4fRI-T6VPfOmLqtWiW2LjY8dzStE2Uq9dYGG75bW3MXRU2uJH8cjct7WCaAbAz7vR3CoxMnqUcpFDSq0IabizesHcBuRe0vBuNTF5CWYcYnJlADSXqT',
                ExerciseCategory.screenStrainRelief,
                exerciseProvider,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String description, String imageUrl, ExerciseCategory category, ExerciseProvider exerciseProvider) {
    final categoryExercises = exerciseProvider.allExercises.where((exercise) => exercise.category == category).toList();
    
    return GestureDetector(
      onTap: () {
        _showCategoryExercises(categoryExercises, title);
      },
      child: Container(
        width: 192, // w-48
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F4), // card-light
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 128, // h-32
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 128,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF10B2D0).withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.visibility,
                        color: Color(0xFF10B2D0),
                        size: 48,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111718), // foreground-light
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF618389), // subtle-light
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${categoryExercises.length} exercises',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10B2D0), // primary
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share Your Progress',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718), // foreground-light
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F4), // card-light
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Share your achievements with friends!',
                style: TextStyle(
                  color: Color(0xFF618389), // subtle-light
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAnHbJLQBqdUa-Tks54DFBv4bAqtWPpgnY71litB4MtjoZPiAVG9D0_EcXyiXUNXa5Ls_Ab-UrmeZOcC-36_3fWZu0ksjA5ldsuVSCVsYGx-WKlhfkzVWfr0_fh9uQDIWNTUiCBw0NfBwshtaWZcYqdnbjSaooX-OSv2jnZPXLTN0Dp8AN1_XkRxcFUX0yslT2-fRy1ijSkfqo9T9NVXp_feJ5qA5HYMbf6igrb9UnSF3I9HrJ4exGapqjOwlVfDShgK_Ub0bYId7Vq',
                    'Facebook',
                  ),
                  _buildSocialButton(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDhawAnsX5USv9smPljW2cr2Bd1ogXKx2BO01-cKmMcXwN2UPj4DeVTuZQVSEFAzEQuN4yrXSD9MUqMRNel5X55yyYx1hLufsnJXhmDEb2kl44LOwBSYm6VobdXJMGk7gfVwfkAHhnpGXcL8o6iMmEyhGUjZauSoDPoT98sj-ARjOwDL06gA1D8goos6WUtP9M8FqIxVQSGdtj8XVe2ol3LnRnWFjTkoK1UH_TMShHPh2PlfDOILwVhTQHfd4R01PuNi-V2iOD5HtgF',
                    'Twitter',
                  ),
                  _buildSocialButton(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAqRXlZADtWNXPFrnyewXwwsE_UOyyphZ4Ua-YgbATRVY2UZyEZGUPsdgq22JBpAIelOuf8sCup5Jvrng83AgTx8mykMIW81J_ileta1o78f9HsW1BFSZV4p_Oeev3sGoZTKhAOrX321-H7lYXGb9fiKeOmjvHuntQYkoRrElCEJ3qPg4x1nO73_mxRwevknlqT6usq-i0dO_fCrgwVLAbiyk_t1CIMFv_SScycyWEgLIx2GKuq0AXZjSs-xvMCSNTbQGhOWcpNObKG',
                    'Instagram',
                  ),
                  _buildSocialButton(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA0PP4Lh1L8RGp_OxFrZH9WI9Z2-FjaPrm8O9Bo0FnEFN5f6_ecY7JfliQvO1pcJ-S-VxwyQJ_DHe0_S7LDzN1J-wIomb1ICI0KvD34Zb2_2Rln8wGQb18q8vFlBDdEBFGTaizL7UtRf8W7a0Ap7ADB8B1G2QAzEdRuMjRNPlgUz8WkW41OEu5VurgXCMSw1JTDHjEm6tgDzz-SJGuHBQmIX8477TtWFG0lJZ3KDpX33S-n00e_i083OBTzVIY-wiCKtW1sSMZvqjJs',
                    'WhatsApp',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(String imageUrl, String platform) {
    return GestureDetector(
      onTap: () {
        // Handle social sharing
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Share to $platform'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF10B2D0).withValues(alpha: 0.2), // primary/20
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Image.network(
            imageUrl,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.share,
                color: const Color(0xFF10B2D0),
                size: 24,
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper methods
  IconData _getExerciseIcon(String iconName) {
    switch (iconName) {
      case 'visibility_off':
        return Icons.visibility_off;
      case 'zoom_out_map':
        return Icons.zoom_out_map;
      case 'blur_on':
        return Icons.blur_on;
      case 'center_focus_strong':
        return Icons.center_focus_strong;
      case 'flare':
        return Icons.flare;
      case 'visibility':
        return Icons.visibility;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'timer':
        return Icons.timer;
      case 'pan_tool':
        return Icons.pan_tool;
      case 'gesture':
        return Icons.gesture;
      case 'text_fields':
        return Icons.text_fields;
      case 'computer':
        return Icons.computer;
      case 'access_time':
        return Icons.access_time;
      default:
        return Icons.visibility;
    }
  }

  void _startExercise(Exercise exercise) {
    // Start the exercise session
    context.read<ExerciseProvider>().startExerciseSession(exercise.id);
    
    // Show exercise details dialog or navigate to exercise screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Duration: ${(exercise.durationSeconds / 60).round()} minutes',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF10B2D0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Difficulty: ${exercise.difficulty.name.toUpperCase()}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF618389),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              exercise.instructions,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would navigate to the actual exercise screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Starting ${exercise.name}...'),
                  backgroundColor: const Color(0xFF10B2D0),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B2D0),
              foregroundColor: Colors.white,
            ),
            child: const Text('Start Exercise'),
          ),
        ],
      ),
    );
  }

  void _showCategoryExercises(List<Exercise> exercises, String categoryName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111718),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildExerciseCard(
                      exercise.name,
                      '${(exercise.durationSeconds / 60).round()} minutes',
                      _getExerciseIcon(exercise.iconName),
                      0.0,
                      false,
                      exercise: exercise,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}