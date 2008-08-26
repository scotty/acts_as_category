module ActsAsCategoryHelper
  
  def category_tree(model, display_type, ajaxurl = nil, column = 'name')
    raise "Model '#{model.to_s}' does not acts_as_category" unless model.respond_to?(:acts_as_category)
    case display_type
      when 'sortable' 
        result = '<div id="sortable_category_response"></div>'
        model.roots.each { |root| result += sortable_category_list(root, ajaxurl, column) }
      when 'public'
        result = ''
        model.roots.each { |root| result += public_category_list(root, column) }
      when 'placement'
        result = ''
        model.roots.each { |root| result += placement_category_list(root, column) }
    end
    result
  end
  
  def sortable_categories(model, ajaxurl = {:controller => :funkengallery, :action => :update_positions}, column = 'name')
    raise "Model '#{model.to_s}' does not acts_as_category" unless model.respond_to?(:acts_as_category)
    result = '<div id="sortable_category_response" "></div>'
    model.roots.each { |root| result += sortable_category_list(root, ajaxurl, column) }
    result
  end

  private
  
  def sortable_category_list(category, ajaxurl, column = 'name')
    parent_id = category.parent ? category.parent.id.to_s : '0'
    firstitem = category.read_attribute(category.position_column) == 1
    lastitem  = category.position == category.self_and_siblings.size
    result = ''
    result += "<ul id=\"sortable_categories_#{parent_id}\">\n" if firstitem
    result += "<li id=\"category_#{category.id}\">"
    result += "<a href=\"/categories/new?parent_id=#{category.id}\">+</a> "
    result += "#{link_to category.read_attribute(column), edit_category_url(category)}"
    result += category.children.empty? ? "</li>\n" : "\n"
    category.children.each {|child| result += sortable_category_list(child, ajaxurl, column = 'name') } unless category.children.empty?
    result += "</ul></li>\n" + sortable_element("sortable_categories_#{parent_id}", :update => 'sortable_category_response', :url => ajaxurl) if lastitem
    result
  end

  def placement_category_list(category, column = 'name')
    parent_id = category.parent ? category.parent.id.to_s : '0'
    firstitem = category.read_attribute(category.position_column) == 1
    lastitem  = category.position == category.self_and_siblings.size
    
    result = ''
    result += "<ul id=\"sortable_categories_#{parent_id}\">\n" if firstitem
    result += "<li id=\"category_#{category.id}\">"
    result += "<input type='checkbox' value='1' id='category_#{category.id}' /> "
    result += category.read_attribute(column)
    result += category.children.empty? ? "</li>\n" : "\n"
    category.children.each { |child| result += placement_category_list(child, column = 'name') } unless category.children.empty?
    result += "</ul></li>\n" if lastitem
    result += "</ul>"
    result
  end

  def public_category_list(category, column = 'name')
    parent_id = category.parent ? category.parent.id.to_s : '0'
    firstitem = category.read_attribute(category.position_column) == 1
    lastitem  = category.position == category.self_and_siblings.size
    
    result = ''
    result += "<ul id=\"sortable_categories_#{parent_id}\">\n" if firstitem
    result += "<li id=\"category_#{category.id}\">"
    result += "<a href=\"/categories/new?parent_id=#{category.id}\">+</a>"
    result += "#{link_to category.read_attribute(column), edit_category_url(category)}"
    result += category.children.empty? ? "</li>\n" : "\n"
    
    category.children.each { |child| 
      result += public_category_list(child, column = 'name') 
    } unless category.children.empty?
  end
  
end
