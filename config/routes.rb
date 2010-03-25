ActionController::Routing::Routes.draw do |map|

  # Internal Search API.
  # /search/documents.json
  # /search/notes.json

  # API Controller uses default routes, for now.

  # Journalist workspace and surrounding HTML.
  map.with_options :controller => 'workspace' do |main|
    main.root
    main.home       '/future_home', :action => 'home' # re-enable this route after launch, until then, it's static/home
    main.results    '/results',     :action => 'index'
    main.signup     '/signup',      :action => 'signup_info'
    main.login      '/login',       :action => 'login'
    main.logout     '/logout',      :action => 'logout'
  end

  # Document representations and (private) sub-resources.
  map.resources  :documents,
                 :collection => {:entities => :get, :dates => :get, :status => :get, :loader => :get},
                 :member     => {:search => :get},
                 :has_many   => [:annotations]
  map.pdf        "/documents/:id/:slug.pdf",      :controller => :documents, :action => :send_pdf
  map.full_text  "/documents/:id/:slug.txt",      :controller => :documents, :action => :send_full_text
  map.page_text  "/documents/:id/pages/:page_name.txt", :controller => :documents, :action => :send_page_text, :conditions => {:method => :get}
  map.set_text   "/documents/:id/pages/:page_name.txt", :controller => :documents, :action => :set_page_text,  :conditions => {:method => :post}
  map.page_image "/documents/:id/pages/:page_name.gif", :controller => :documents, :action => :send_page_image


  # Bulk downloads.
  map.bulk_download '/download/*args.zip', :controller => 'download', :action => 'bulk_download'

  # Accounts and account management.
  map.resources :accounts
  map.with_options :controller => 'accounts' do |accounts|
    accounts.enable_account '/accounts/enable/:key', :action => 'enable'
    accounts.reset_password '/reset_password', :action => 'reset'
  end

  # Projects.
  map.resources :projects, :member => {:documents => :get}

  # Static pages.
  map.with_options :controller => 'static' do |static|
    static.contributors   '/contributors',  :action => 'contributors'
    static.faq            '/faq',           :action => 'faq'
    static.terms          '/terms',         :action => 'terms'
    static.privacy        '/privacy',       :action => 'privacy'
    static.home           '/home',          :action => 'home'
    static.news           '/news',          :action => 'news'
    static.opensource     '/opensource',    :action => 'opensource'
    static.about          '/about',         :action => 'about'
    static.contact        '/contact',       :action => 'contact'
  end

  # Redirects.
  map.with_options :controller => 'redirect' do |move|
    move.faq              '/faq.php',       :url => '/faq'
    move.who              '/who.php',       :url => '/about'
    move.who_we_are       '/who-we-are',    :url => '/about'
    move.partner          '/partner.php',   :url => '/contributors'
    move.clips            '/clips.php',     :url => '/news'
    move.feed             '/blog/feed',     :url => 'http://blog.documentcloud.org/feed'
    move.root_feed        '/feed',          :url => 'http://blog.documentcloud.org/feed'
    move.blog             '/blog/*parts',   :url => 'http://blog.documentcloud.org/'
  end

  # Asset packages.
  Jammit::Routes.draw(map)

  # Default routes:
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
end
