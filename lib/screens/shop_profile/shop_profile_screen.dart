import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jara_vendor/screens/shop_profile/controller/shop_profile_controller.dart';

/// Post-onboarding editing of the two things that decide which orders reach
/// this vendor: the market they trade from, and the categories they carry.
class ShopProfileScreen extends StatelessWidget {
  const ShopProfileScreen({super.key});

  static const Color _amber = Color(0xFFFFAA00);

  @override
  Widget build(BuildContext context) {
    final ShopProfileController c = Get.isRegistered<ShopProfileController>()
        ? Get.find<ShopProfileController>()
        : Get.put(ShopProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Shop Details',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: _amber));
        }
        if (c.errorMessage.value.isNotEmpty) {
          return _Retry(message: c.errorMessage.value, onRetry: c.load);
        }
        return RefreshIndicator(
          color: _amber,
          onRefresh: c.load,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'These decide which orders you get offered. You can change them '
                'whenever you move or start stocking something new.',
                style: TextStyle(fontSize: 13, color: Color(0xFF666666), height: 1.5),
              ),
              const SizedBox(height: 20),
              _Card(
                title: 'Market',
                subtitle: c.currentMarket.value == null
                    ? 'Not set — you will not receive orders until you pick one'
                    : c.currentMarket.value!.name,
                detail: c.currentMarket.value == null
                    ? null
                    : [
                        c.currentMarket.value!.lgaName,
                        c.currentMarket.value!.stateName,
                      ].whereType<String>().join(', '),
                warning: c.currentMarket.value == null,
                actionLabel: c.currentMarket.value == null ? 'Choose' : 'Change',
                onTap: () => _openMarketSheet(context, c),
              ),
              const SizedBox(height: 14),
              _Card(
                title: 'Categories',
                subtitle: c.currentCategories.isEmpty
                    ? 'None selected — you will not be matched to any order'
                    : c.currentCategories.map((e) => e.name).join(', '),
                detail: c.currentCategories.isEmpty
                    ? null
                    : '${c.currentCategories.length} selected',
                warning: c.currentCategories.isEmpty,
                actionLabel: c.currentCategories.isEmpty ? 'Choose' : 'Change',
                onTap: () {
                  c.resetDraft();
                  c.fetchCategories();
                  _openCategorySheet(context, c);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  // ── Market picker ─────────────────────────────────────────────────────────

  void _openMarketSheet(BuildContext context, ShopProfileController c) {
    c.fetchMarkets();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Column(
          children: [
            const _SheetHandle(),
            const _SheetTitle('Choose your market'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Obx(() => Row(
                    children: [
                      Expanded(
                        child: _Dropdown<int>(
                          hint: 'State',
                          value: c.selectedState.value?.id,
                          items: [
                            for (final s in c.states)
                              DropdownMenuItem(value: s.id, child: Text(s.name ?? '')),
                          ],
                          onChanged: (id) => c.onStateChanged(
                              c.states.firstWhereOrNull((s) => s.id == id)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Dropdown<int>(
                          hint: c.isLoadingLgas.value ? 'Loading…' : 'LGA',
                          value: c.selectedLga.value?.id,
                          items: [
                            for (final l in c.lgas)
                              DropdownMenuItem(value: l.id, child: Text(l.name ?? '')),
                          ],
                          onChanged: c.selectedState.value == null
                              ? null
                              : (id) => c.onLgaChanged(
                                  c.lgas.firstWhereOrNull((l) => l.id == id)),
                        ),
                      ),
                    ],
                  )),
            ),
            Expanded(
              child: Obx(() {
                if (c.isLoadingMarkets.value) {
                  return const Center(
                      child: CircularProgressIndicator(color: _amber));
                }
                if (c.markets.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No markets here yet. Try a different state or LGA.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF888888))),
                    ),
                  );
                }
                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: c.markets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final m = c.markets[i];
                    final isCurrent = c.currentMarket.value?.id == m.id;
                    return Obx(() => _SelectableRow(
                          title: m.name,
                          subtitle: [m.lgaName, m.stateName]
                              .whereType<String>()
                              .join(', '),
                          selected: isCurrent,
                          busy: c.isSaving.value,
                          trailingLabel: isCurrent ? 'Current' : null,
                          onTap: isCurrent ? null : () => c.saveMarket(m),
                        ));
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Category picker ───────────────────────────────────────────────────────

  void _openCategorySheet(BuildContext context, ShopProfileController c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Column(
          children: [
            const _SheetHandle(),
            const _SheetTitle('What do you sell?'),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                'Pick every category you can supply. Orders are offered to you '
                'based on these.',
                style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (c.isLoadingCategories.value) {
                  return const Center(
                      child: CircularProgressIndicator(color: _amber));
                }
                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  itemCount: c.allCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final cat = c.allCategories[i];
                    return Obx(() => _SelectableRow(
                          title: cat.name,
                          subtitle: cat.description,
                          selected: c.draftCategoryIds.contains(cat.id),
                          checkbox: true,
                          onTap: () => c.toggleCategory(cat.id),
                        ));
                  },
                );
              }),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: c.isSaving.value ? null : c.saveCategories,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _amber,
                          disabledBackgroundColor: const Color(0xFFE0E0E0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: c.isSaving.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.2, color: Colors.white))
                            : Text(
                                'Save ${c.draftCategoryIds.length} '
                                '${c.draftCategoryIds.length == 1 ? "category" : "categories"}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small building blocks ───────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? detail;
  final String actionLabel;
  final bool warning;
  final VoidCallback onTap;

  const _Card({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
    this.detail,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(14, 45, 45, 1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: warning
                ? const Color(0xFFE53935).withOpacity(0.5)
                : const Color.fromARGB(88, 128, 128, 128)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666))),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: warning ? const Color(0xFFE53935) : Colors.black)),
                if (detail != null) ...[
                  const SizedBox(height: 2),
                  Text(detail!,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF888888))),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFFAA00),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFFFFAA00))),
            ),
            child: Text(actionLabel,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _SelectableRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final bool checkbox;
  final bool busy;
  final String? trailingLabel;
  final VoidCallback? onTap;

  const _SelectableRow({
    required this.title,
    required this.selected,
    this.subtitle,
    this.checkbox = false,
    this.busy = false,
    this.trailingLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: busy ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF6E5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected
                  ? const Color(0xFFFFAA00)
                  : const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            if (checkbox)
              Icon(
                selected ? Icons.check_box : Icons.check_box_outline_blank,
                color: selected ? const Color(0xFFFFAA00) : const Color(0xFFBDBDBD),
                size: 22,
              ),
            if (checkbox) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF888888))),
                  ],
                ],
              ),
            ),
            if (trailingLabel != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFAA00),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(trailingLabel!,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              )
            else if (!checkbox)
              const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
          ],
        ),
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const _Dropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      hint: Text(hint, style: const TextStyle(fontSize: 13)),
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) => Container(
        width: 42,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(4)),
      );
}

class _SheetTitle extends StatelessWidget {
  final String text;
  const _SheetTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins')),
        ),
      );
}

class _Retry extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  const _Retry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAA00)),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
}
