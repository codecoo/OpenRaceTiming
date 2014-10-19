library bwu_datagrid.compponents.bwu_pager;

import 'dart:html' as dom;

import 'package:polymer/polymer.dart';
import 'package:bwu_utils_browser/math/parse_num.dart' as tools;

import 'package:bwu_datagrid/bwu_datagrid.dart';
import 'package:bwu_datagrid/datagrid/helpers.dart';
import 'package:bwu_datagrid/dataview/dataview.dart';
import 'package:bwu_datagrid/core/core.dart' as core;

class NavState extends ChangeNotifier {
  @reflectable @observable bool get canGotoFirst => __$canGotoFirst; bool __$canGotoFirst; @reflectable set canGotoFirst(bool value) { __$canGotoFirst = notifyPropertyChange(#canGotoFirst, __$canGotoFirst, value); }
  @reflectable @observable bool get canGotoLast => __$canGotoLast; bool __$canGotoLast; @reflectable set canGotoLast(bool value) { __$canGotoLast = notifyPropertyChange(#canGotoLast, __$canGotoLast, value); }
  @reflectable @observable bool get canGotoPrev => __$canGotoPrev; bool __$canGotoPrev; @reflectable set canGotoPrev(bool value) { __$canGotoPrev = notifyPropertyChange(#canGotoPrev, __$canGotoPrev, value); }
  @reflectable @observable bool get canGotoNext => __$canGotoNext; bool __$canGotoNext; @reflectable set canGotoNext(bool value) { __$canGotoNext = notifyPropertyChange(#canGotoNext, __$canGotoNext, value); }
  PagingInfo pagingInfo;

  NavState({canGotoFirst, canGotoLast,   canGotoPrev, canGotoNext}) : __$canGotoFirst = canGotoFirst, __$canGotoLast = canGotoLast, __$canGotoPrev = canGotoPrev, __$canGotoNext = canGotoNext;
}

@CustomTag('bwu-pager')
class BwuPager extends PolymerElement with ChangeNotifier  {
  BwuPager.created() : super.created();

  bool _isInitialized = false;

  DataView _dataView;
  BwuDatagrid _grid;

  @reflectable @observable bool get pagerSettingsExpanded => __$pagerSettingsExpanded; bool __$pagerSettingsExpanded = true; @reflectable set pagerSettingsExpanded(bool value) { __$pagerSettingsExpanded = notifyPropertyChange(#pagerSettingsExpanded, __$pagerSettingsExpanded, value); }
  @reflectable @observable String get pagerStatusText => __$pagerStatusText; String __$pagerStatusText = ''; @reflectable set pagerStatusText(String value) { __$pagerStatusText = notifyPropertyChange(#pagerStatusText, __$pagerStatusText, value); }
  @observable final NavState navState = new NavState();

  dom.HtmlElement $status;

  void init(DataView dataView, BwuDatagrid grid) {
    _dataView = dataView;
    _grid = grid;
    _dataView.onBwuPagingInfoChanged.listen((e) {
      updatePager(e.pagingInfo);
    });

    updatePager(_dataView.getPagingInfo());
  }

  void updateNavState() {
    bool cannotLeaveEditMode = !core.globalEditorLock.commitCurrentEdit();
    navState.pagingInfo = _dataView.getPagingInfo();
    int lastPage = navState.pagingInfo.totalPages - 1;

    navState.canGotoFirst = !cannotLeaveEditMode && navState.pagingInfo.pageSize != 0 && navState.pagingInfo.pageNum > 0;
    navState.canGotoLast = !cannotLeaveEditMode && navState.pagingInfo.pageSize != 0 && navState.pagingInfo.pageNum != lastPage;
    navState.canGotoPrev = !cannotLeaveEditMode && navState.pagingInfo.pageSize != 0 && navState.pagingInfo.pageNum > 0;
    navState.canGotoNext = !cannotLeaveEditMode && navState.pagingInfo.pageSize != 0 && navState.pagingInfo.pageNum < lastPage;
  }

  void setPageSize(int n) {
    _dataView.setRefreshHints({
      'isFilterUnchanged': true
    });
    _dataView.setPagingOptions(new PagingInfo(pageSize: n));
  }

  void gotoFirst(dom.MouseEvent e, detail, dom.HtmlElement target) {
    updateNavState();
    if (navState.canGotoFirst) {
      _dataView.setPagingOptions(new PagingInfo(pageNum: 0));
    }
  }

  void gotoLast(dom.MouseEvent e, detail, dom.HtmlElement target) {
    updateNavState();
    if (navState.canGotoLast) {
      _dataView.setPagingOptions(new PagingInfo(pageNum: navState.pagingInfo.totalPages - 1));
    }
  }

  void gotoPrev(dom.MouseEvent e, detail, dom.HtmlElement target) {
    updateNavState();
    if (navState.canGotoPrev) {
      _dataView.setPagingOptions(new PagingInfo(pageNum: navState.pagingInfo.pageNum - 1));
    }
  }

  void gotoNext(dom.MouseEvent e, detail, dom.HtmlElement target) {
    updateNavState();
    if (navState.canGotoNext) {
      _dataView.setPagingOptions(new PagingInfo(pageNum: navState.pagingInfo.pageNum + 1));
    }
  }

  void pageSizeClickHandler(dom.MouseEvent e, detail, dom.HtmlElement target) {
    int pagesize = tools.parseInt((e.target as dom.HtmlElement).dataset['value'], onErrorDefault: 0);
    //if (pagesize != 0) {
      if (pagesize == -1) {
        Range vp = _grid.getViewport();
        setPageSize(vp.bottom - vp.top);
      } else {
        setPageSize(pagesize);
      }
    //}
  }

  void toggleMouseOver(dom.MouseEvent e, detail, dom.HtmlElement target) {
    target.classes.add('ui-state-hover');
  }

  void toggleMouseOut(dom.MouseEvent e, detail, dom.HtmlElement target) {
    target.classes.remove('ui-state-hover');
  }


  void expandPagerSettingsClickHandler(dom.MouseEvent e, detail, dom.HtmlElement target) {
    pagerSettingsExpanded = !pagerSettingsExpanded;
  }

  void updatePager(PagingInfo pagingInfo) {
    updateNavState();

    if (pagingInfo.pageSize == 0) {
      var totalRowsCount = _dataView.getItems().length;
      var visibleRowsCount = pagingInfo.totalRows;
      if (visibleRowsCount < totalRowsCount) {
        pagerStatusText = 'Showing ${visibleRowsCount} of ${totalRowsCount} rows';
      } else {
        pagerStatusText = 'Showing all ${totalRowsCount} rows';
      }
      pagerStatusText = 'Showing all ${pagingInfo.totalRows} rows';
    } else {
      pagerStatusText = 'Showing page ${pagingInfo.pageNum + 1} of ${pagingInfo.totalPages}';
    }
  }
}