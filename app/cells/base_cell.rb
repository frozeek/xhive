class BaseCell < Cell::Base
  def self.render_action(action, attrs)
    result = Cell::Base.render_cell_for(self.name.underscore, action, attrs)
  rescue e
    result = ''
    logger.error "#{e.class.name}: #{e.message}"
  ensure
    return result
  end
end
