import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/controllers/dashboard_controller.dart';
import 'package:flutter_view_controller/new_screens/dashboard/components/profile_tile.dart';
import 'package:flutter_view_controller/new_screens/dashboard/components/sidebar.dart';
import 'package:flutter_view_controller/shared_components/chatting_card.dart';
import 'package:flutter_view_controller/shared_components/progress_card.dart';
import 'package:flutter_view_controller/shared_components/progress_report_card.dart';
import 'package:flutter_view_controller/shared_components/project_card.dart';
import 'package:flutter_view_controller/shared_components/responsive_builder.dart';
import 'package:flutter_view_controller/shared_components/task_card.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../screens/web/components/header.dart';
import '../../shared_components/get_premium_card.dart';
import '../../shared_components/list_profil_image.dart';
import 'components/active_project_card.dart';
import 'components/overview_header.dart';
import 'components/recent_messages.dart';
import 'components/team_member.dart';

enum TaskType {
  todo,
  inProgress,
  done,
}

class Profile {
  final ImageProvider photo;
  final String name;
  final String email;

  const Profile({
    required this.photo,
    required this.name,
    required this.email,
  });
}

// models
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: kSpacing),
                child: Sidebar(data: controller.getSelectedProject()),
              ),
            ),
      body: SingleChildScrollView(
          child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(onPressedMenu: () => controller.openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: controller.getProfil()),
            const SizedBox(height: kSpacing),
            _buildProgress(axis: Axis.vertical),
            const SizedBox(height: kSpacing),
            _buildTeamMember(data: controller.getMember()),
            const SizedBox(height: kSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing),
              child: GetPremiumCard(onPressed: () {}),
            ),
            const SizedBox(height: kSpacing * 2),
            _buildTaskOverview(
              data: controller.getAllTask(),
              headerAxis: Axis.vertical,
              crossAxisCount: 6,
              crossAxisCellCount: 6,
            ),
            const SizedBox(height: kSpacing * 2),
            _buildActiveProject(
              data: controller.getActiveProject(),
              crossAxisCount: 6,
              crossAxisCellCount: 6,
            ),
            const SizedBox(height: kSpacing),
            _buildRecentMessages(data: controller.getChatting()),
          ]);
        },
        tabletBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 950) ? 6 : 9,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                    _buildHeader(onPressedMenu: () => controller.openDrawer()),
                    const SizedBox(height: kSpacing * 2),
                    _buildProgress(
                      axis: (constraints.maxWidth < 950)
                          ? Axis.vertical
                          : Axis.horizontal,
                    ),
                    const SizedBox(height: kSpacing * 2),
                    _buildTaskOverview(
                      data: controller.getAllTask(),
                      headerAxis: (constraints.maxWidth < 850)
                          ? Axis.vertical
                          : Axis.horizontal,
                      crossAxisCount: 6,
                      crossAxisCellCount: (constraints.maxWidth < 950)
                          ? 6
                          : (constraints.maxWidth < 1100)
                              ? 3
                              : 2,
                    ),
                    const SizedBox(height: kSpacing * 2),
                    _buildActiveProject(
                      data: controller.getActiveProject(),
                      crossAxisCount: 6,
                      crossAxisCellCount: (constraints.maxWidth < 950)
                          ? 6
                          : (constraints.maxWidth < 1100)
                              ? 3
                              : 2,
                    ),
                    const SizedBox(height: kSpacing),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing * (kIsWeb ? 0.5 : 1.5)),
                    _buildProfile(data: controller.getProfil()),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    _buildTeamMember(data: controller.getMember()),
                    const SizedBox(height: kSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                      child: GetPremiumCard(onPressed: () {}),
                    ),
                    const SizedBox(height: kSpacing),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    _buildRecentMessages(data: controller.getChatting()),
                  ],
                ),
              )
            ],
          );
        },
        desktopBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 1360) ? 4 : 3,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(kBorderRadius),
                      bottomRight: Radius.circular(kBorderRadius),
                    ),
                    child: Sidebar(data: controller.getSelectedProject())),
              ),
              Flexible(
                flex: 9,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing),
                    _buildHeader(),
                    const SizedBox(height: kSpacing * 2),
                    _buildProgress(),
                    const SizedBox(height: kSpacing * 2),
                    _buildTaskOverview(
                      data: controller.getAllTask(),
                      crossAxisCount: 6,
                      crossAxisCellCount: (constraints.maxWidth < 1360) ? 3 : 2,
                    ),
                    const SizedBox(height: kSpacing * 2),
                    _buildActiveProject(
                      data: controller.getActiveProject(),
                      crossAxisCount: 6,
                      crossAxisCellCount: (constraints.maxWidth < 1360) ? 3 : 2,
                    ),
                    const SizedBox(height: kSpacing),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing / 2),
                    _buildProfile(data: controller.getProfil()),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    _buildTeamMember(data: controller.getMember()),
                    const SizedBox(height: kSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                      child: GetPremiumCard(onPressed: () {}),
                    ),
                    const SizedBox(height: kSpacing),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    _buildRecentMessages(data: controller.getChatting()),
                  ],
                ),
              )
            ],
          );
        },
      )),
    );
  }

  Widget _buildHeader({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: kSpacing),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "menu",
              ),
            ),
          Expanded(child: Header()),
        ],
      ),
    );
  }

  Widget _buildProgress({Axis axis = Axis.horizontal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: (axis == Axis.horizontal)
          ? Row(
              children: [
                Flexible(
                  flex: 5,
                  child: ProgressCard(
                    data: const ProgressCardData(
                      totalUndone: 10,
                      totalTaskInProress: 2,
                    ),
                    onPressedCheck: () {},
                  ),
                ),
                const SizedBox(width: kSpacing / 2),
                const Flexible(
                  flex: 4,
                  child: ProgressReportCard(
                    data: ProgressReportCardData(
                      title: "1st Sprint",
                      doneTask: 5,
                      percent: .3,
                      task: 3,
                      undoneTask: 2,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                ProgressCard(
                  data: const ProgressCardData(
                    totalUndone: 10,
                    totalTaskInProress: 2,
                  ),
                  onPressedCheck: () {},
                ),
                const SizedBox(height: kSpacing / 2),
                const ProgressReportCard(
                  data: ProgressReportCardData(
                    title: "1st Sprint",
                    doneTask: 5,
                    percent: .3,
                    task: 3,
                    undoneTask: 2,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTaskOverview({
    required List<TaskCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
    Axis headerAxis = Axis.horizontal,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: data.length + 1,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return (index == 0)
            ? Padding(
                padding: const EdgeInsets.only(bottom: kSpacing),
                child: OverviewHeader(
                  axis: headerAxis,
                  onSelected: (task) {},
                ),
              )
            : TaskCard(
                data: data[index - 1],
                onPressedMore: () {},
                onPressedTask: () {},
                onPressedContributors: () {},
                onPressedComments: () {},
              );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit((index == 0) ? crossAxisCount : crossAxisCellCount),
    );
  }

  Widget _buildActiveProject({
    required List<ProjectCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: ActiveProjectCard(
        onPressedSeeAll: () {},
        child: StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          itemCount: data.length,
          addAutomaticKeepAlives: false,
          mainAxisSpacing: kSpacing,
          crossAxisSpacing: kSpacing,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ProjectCard(data: data[index]);
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ),
    );
  }

  Widget _buildProfile({required Profile data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: ProfilTile(
        data: data,
        onPressedNotification: () {},
      ),
    );
  }

  Widget _buildTeamMember({required List<ImageProvider> data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeamMember(
            totalMember: data.length,
            onPressedAdd: () {},
          ),
          const SizedBox(height: kSpacing / 2),
          ListProfilImage(maxImages: 6, images: data),
        ],
      ),
    );
  }

  Widget _buildRecentMessages({required List<ChattingCardData> data}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: RecentMessages(onPressedMore: () {}),
      ),
      const SizedBox(height: kSpacing / 2),
      ...data
          .map(
            (e) => ChattingCard(data: e, onPressed: () {}),
          )
          .toList(),
    ]);
  }
}
