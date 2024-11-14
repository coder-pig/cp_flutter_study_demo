import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// [State] 的扩展，用于在小部件未挂载时安全地调用 [setState]。
extension SafeUpdateState on State {
  void safeSetState(VoidCallback fn) {
    void callSetState() {
      if (mounted) setState(fn);  // 只有在挂载时才能调用 setState
    }

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // 当前正在构建，不能调用 setState -- 添加帧后回调
      SchedulerBinding.instance.addPostFrameCallback((_) => callSetState());
    } else {
      callSetState();
    }
  }
}