enum AppRoute {
  home('/homepage'),
  settings('/settings'),
  auth('/auth'),
  favorites('/favorites'),
  learning('/learn'),
  cardBoxInfo('/card_box_info'),
  cardsPage('/cards_page'),
  ;

  const AppRoute(this.path);
  final String path;
}
