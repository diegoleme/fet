#!/usr/bin/env ruby

#########################
# Preprocessing
#########################

preprocess do

  config[:authors] = []

  @items.each do |item|
    unless item[:author].nil? || item[:author].empty?
      config[:authors] = config[:authors] | [ item[:author] ]
    end
  end

  config[:authors].each do |author|
    @items << Nanoc3::Item.new(
      "== render 'talk-list', :itemsList => items_with(:author, '#{author}')",
      { :extension => 'html', :is_hidden => true, :priority => 0.3 },
      "/tags/#{toURL(author)}/"
    )
  end

  config[:events] = []

  @items.each do |item|
    unless item[:event].nil? || item[:event].empty?
      config[:events] = config[:events] | [ item[:event] ]
    end
  end

  config[:events].each do |event|
    @items << Nanoc3::Item.new(
      "== render 'talk-list', :itemsList => items_with(:event, '#{event}')",
      { :extension => 'html', :is_hidden => true, :priority => 0.3 },
      "/tags/#{toURL(event)}/"
    )
  end

  @items.each do |item|
    if %w{png gif jpg jpeg coffee scss sass less css xml js txt}.include?(item[:extension]) ||
        item.identifier =~ /404|500|htaccess/
      item[:is_hidden] = true unless item.attributes.has_key?(:is_hidden)
    end
  end

  @items << Nanoc3::Item.new(
    "<%= xml_sitemap {} %>",
    { :extension => 'xml', :is_hidden => true },
    '/sitemap/'
  )

  config[:nanoc_version_info] = 'nanoc --version'.strip
  config[:gem_version_info]   = 'gem --version'.strip

end

#########################
# Resize Images
#########################

sizes = [ '200x200^', '240x160^', '800x250^', '800x600' ]

sizes.each do |size|
  route '/imagens/*/', rep: size do
    get_image_url item, size.gsub('^', '')
  end

  compile '/imagens/*/', rep: size do
    filter :thumbnailize, :size => size, :position => item[:position][size.to_sym] || '+0+0'
    filter :image_compressor, :pngout => false
  end
end

route '/(img|imagens)/*/' do
  get_image_url item
end

compile '/(img|imagens)/*/' do
  filter :image_compressor, :pngout => false
end


#########################
# Routing
#########################

route %r{.*\/_.*} do
end

route '/static/*' do
  item.identifier[7..-2]
end

route '/css/*' do
  item.identifier.chop + '.' + item[:extension]
end

route '/less/*' do
  item.identifier.chop.gsub(/less/,'css') + '.css'
end

route '/sass/*' do
    item.identifier.chop.gsub(/sass/,'css') + '.css'
end

route '/js/*' do
  item.identifier.chop + '.' + item[:extension]
end

route '/coffee/*' do
  item.identifier.chop.gsub(/coffee/,'js') + '.js'
end

route '/sitemap/' do
  '/sitemap.xml'
  # '/sitemap.xml.gz'
end

route '/articles/*' do
  item.identifier[9..-1] + 'index.html'
end

route '/tags/*' do
  item.identifier[5..-1] + 'index.html'
end

route '*' do
  if item.binary?
    item.identifier.chop + '.' + item[:extension]
  else
    item.identifier + 'index.html'
  end
end

#########################
# Compilation
#########################

compile %r{.*\/_.*} do
end

compile '/static/*' do
end

compile '/css/*' do
  # filter :kss
  filter :yui_compressor, :type => :css
end

compile '/less/*' do
  filter :less, :compress => true
end

compile '/sass/*' do
  filter :sass
  filter :yui_compressor, :type => :css
end

compile '/js/*' do
  filter :concat
  filter :uglify_js, :copyright => false
end

compile '/coffee/*' do
  filter :coffeescript
  filter :concat
  filter :uglify_js, :copyright => false
end

compile '/sitemap/' do
  filter :erb
  # filter :shellcmd, :cmd => 'gzip'
end

compile '/articles/*' do
  filter :slim #, :pretty => true
  filter :html_compressor
  layout 'article'
end

compile '/tags/*' do
  filter :slim #, :pretty => true
  filter :html_compressor
  layout 'default'
end

compile '*' do
  if item.binary?
  else
    filter :slim #, :pretty => true
    filter :html_compressor
    layout 'default'
  end
end

#########################
# Layouting
#########################

layout '*', :slim #, :pretty => true

# spriteful content/img/sprite -s content/sass/core -d content/img -f scss
