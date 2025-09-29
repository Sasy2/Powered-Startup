import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/user_provider.dart';
import '../models/exercise_model.dart';
import '../widgets/exercise_card.dart';
import '../widgets/daily_plan_card.dart';

class ExercisesScreenNew extends StatefulWidget {
  const ExercisesScreenNew({super.key});

  @override
  State<ExercisesScreenNew> createState() => _ExercisesScreenNewState();
}

class _ExercisesScreenNewState extends State<ExercisesScreenNew> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  void _loadData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    
    if (userProvider.currentUser != null) {
      exerciseProvider.loadExercises();
      exerciseProvider.loadTodayPlan(userProvider.currentUser!.id);
      exerciseProvider.loadUserSessions(userProvider.currentUser!.id);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTodayTab(),
                  _buildExercisesTab(),
                  _buildHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF10B2D0), Color(0xFF0891A6)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Daily Exercises',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<ExerciseProvider>(
            builder: (context, provider, child) {
              if (provider.todayPlan != null) {
                return DailyPlanCard(plan: provider.todayPlan!);
              } else {
                return _buildWelcomeCard();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.fitness_center,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 10),
          const Text(
            'Ready to strengthen your eyes?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Text(
            'Start with our recommended exercises',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF10B2D0),
          borderRadius: BorderRadius.circular(15),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF618389),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Today'),
          Tab(text: 'Exercises'),
          Tab(text: 'History'),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    return Consumer<ExerciseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.todayPlan == null) {
          return _buildNoPlanToday();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressSection(provider),
              const SizedBox(height: 20),
              _buildExercisesList(provider.todayPlan!.exercises),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressSection(ExerciseProvider provider) {
    final progress = provider.getTodayProgress();
    final completed = provider.getTodayCompletedExercises();
    final total = provider.todayPlan?.exercises.length ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF10B2D0).withValues(alpha: 0.1),
            const Color(0xFF4ECDC4).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF10B2D0).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111718),
                ),
              ),
              Text(
                '$completed/$total',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B2D0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B2D0)),
            minHeight: 8,
          ),
          const SizedBox(height: 10),
          Text(
            '${(progress * 100).round()}% Complete',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF618389),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesList(List<PlannedExercise> exercises) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Exercises',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111718),
          ),
        ),
        const SizedBox(height: 15),
        ...exercises.map((exercise) => _buildExerciseItem(exercise)),
      ],
    );
  }

  Widget _buildExerciseItem(PlannedExercise plannedExercise) {
    return Consumer<ExerciseProvider>(
      builder: (context, provider, child) {
        final exercise = provider.getExerciseById(plannedExercise.exerciseId);
        if (exercise == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: ExerciseCard(
            exercise: exercise,
            plannedExercise: plannedExercise,
            onTap: () => _startExercise(exercise),
            onComplete: () => _completeExercise(plannedExercise.exerciseId),
          ),
        );
      },
    );
  }

  Widget _buildNoPlanToday() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.fitness_center_outlined,
            size: 80,
            color: Color(0xFF10B2D0),
          ),
          const SizedBox(height: 20),
          const Text(
            'No exercises planned for today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Check out our exercise library to get started',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF618389),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => _tabController.animateTo(1),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B2D0),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Browse Exercises',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesTab() {
    return Consumer<ExerciseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: provider.exercises.length,
          itemBuilder: (context, index) {
            final exercise = provider.exercises[index];
            return ExerciseCard(
              exercise: exercise,
              onTap: () => _startExercise(exercise),
            );
          },
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<ExerciseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.sessions.isEmpty) {
          return _buildNoHistory();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: provider.sessions.length,
          itemBuilder: (context, index) {
            final session = provider.sessions[index];
            final exercise = provider.getExerciseById(session.exerciseId);
            if (exercise == null) return const SizedBox.shrink();

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B2D0).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Color(0xFF10B2D0),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111718),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${session.duration} seconds • ${_formatDate(session.startTime)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF618389),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (session.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF4ECDC4),
                      size: 24,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNoHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.history,
            size: 80,
            color: Color(0xFF10B2D0),
          ),
          const SizedBox(height: 20),
          const Text(
            'No exercise history yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Complete your first exercise to see it here',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF618389),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDBE4E6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF10B2D0),
          unselectedItemColor: const Color(0xFF618389),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context);
            } else if (index == 1) {
              Navigator.pushNamed(context, '/vision_test');
            } else if (index == 3) {
              Navigator.pushNamed(context, '/chat');
            } else if (index == 4) {
              Navigator.pushNamed(context, '/profile');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility),
              label: 'Vision Test',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy),
              label: 'EyeDoctor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _startExercise(ExerciseModel exercise) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${exercise.name}...'),
        backgroundColor: const Color(0xFF10B2D0),
      ),
    );
  }

  void _completeExercise(String exerciseId) {
    final provider = Provider.of<ExerciseProvider>(context, listen: false);
    provider.completePlannedExercise(exerciseId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exercise completed! Great job!'),
        backgroundColor: Color(0xFF4ECDC4),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

