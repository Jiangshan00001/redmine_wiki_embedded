Redmine::Plugin.register :redmine_wiki_embedded do
  name 'Redmine Wiki Embedded plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end


Redmine::WikiFormatting::Macros.register do
  desc "Embed a Wiki page to another wiki page. Examples:\n\n<pre>{{embedded_wiki(wiki_page_name)}}\n  same as macro{{include}} except it add a link to the included wiki  </pre>"
  macro :embedded_wiki do |wiki_content_obj, args|
    # Parse the file argument. find wiki page
    
        page = Wiki.find_page(args.first.to_s, :project => @project)
        raise 'Page not found' if page.nil? || !User.current.allowed_to?(:view_wiki_pages, page.wiki.project)
        @included_wiki_pages ||= []
        raise 'Circular inclusion detected' if @included_wiki_pages.include?(page.title)
        @included_wiki_pages << page.title
	
	page_cont=page.content.text
	page_cont=page_cont.to_s
	first_line_index=page_cont.index("\n")
	if first_line_index>2
	first_line_index=first_line_index-1
	end
	
	if page_cont.to_s.length>(first_line_index+5)
        	sub1 = page_cont.to_s[first_line_index,page_cont.to_s.length]
	else
        	sub1 = "EMPTY"	
	end
        formatting = Setting.text_formatting
	text = Redmine::WikiFormatting.to_html(formatting, sub1, :object => page.content)
        out = text.html_safe
        @included_wiki_pages.pop
         out =
                  link_to(page.title,
                          controller: 'wiki', action: 'show',
                          project_id: page.project, id: page.title)+"<br/> <div style=' border: #759fcf solid 1px'> ".html_safe+ out +"</div>".html_safe

	out
	
	
  end
end










