module Xhive
  # Maps resources to pages.
  #
  class Mapper < ActiveRecord::Base
    attr_accessible :action, :page_id, :site_id, :resource, :key, :policy

    belongs_to :site
    belongs_to :page

    validates :resource, :presence => true
    validates :action, :presence => true
    validates :site, :presence => true
    validates :page, :presence => true

    # Public: looks for a page mapper and returns the associated page.
    #
    # site     - The Site to look into.
    # resource - The String containing the resource name filter.
    # action   - The String containing the action name filter.
    # key      - The String containing the key filter.
    # opts     - The Hash containing extra values for policy-based filters.
    #
    # Returns: the mapped page or nil if not found.
    #
    def self.page_for(site, resource, action, key = nil, opts = {})
      mapper = find_map(site, resource, action, key, opts)
      page = mapper.try(:page)
    end

    # Public: creates a mapper for a specific resource and page.
    #
    # site     - The Site to associate the mapper to.
    # page     - The Page object to map.
    # resource - The String containing the associated resource name.
    # action   - The String containing the associated action name.
    # key      - The String containing the associated key.
    # policy   - The String containing the policy class.
    #
    # Returns: true if created. False otherwise.
    #
    def self.map_resource(site, page, resource, action, key = nil, policy = nil)
      check_policy_class(policy) if policy.present?

      mapper = find_exact_map(site, resource, action, key, policy)
      mapper = new(:site_id => site.id, :resource => resource,
                   :action => action, :policy => policy,
                   :key => key.present? ? key : nil) unless mapper.present?
      mapper.page = page
      mapper.save
    end

    # Public: returns all the mappers for a specific resource.
    #
    # site     - The Site owner of the mappers.
    # resource - The String containing the resource to filter by.
    #
    # Returns: an ActiveRecord::Relation filtered by resource.
    #
    def self.all_by_resource(site, resource)
      where(:site_id => site.id).where(:resource => resource)
    end

    class InvalidPolicyError < StandardError
      def initialize(name)
        @name = name
      end

      def message
        "#{@name} must implement a ::call method"
      end
    end

  private

    # Private: looks for a mapper object.
    #
    # site     - The Site to look into.
    # resource - The String containing the resource name filter.
    # action   - The String containing the action name filter.
    # key      - The String containing the key filter.
    # opts     - The Hash containing extra values for policy-based filters.
    #
    # Returns:
    #
    #   - The mapper object if it finds a key.
    #   - The default mapper if it does not find a key.
    #   - Nil if there is no default mapper.
    #
    def self.find_map(site, resource, action, key, opts)
      # Create filtering scopes
      scope   = where(:site_id => site.id)
      scope   = scope.where(:resource => resource)
      scope   = scope.where(:action => action)

      # Fetch mappers
      mappers = scope.where(:key => key.present? ? key : nil)
      mappers = scope.where(:key => nil) if mappers.empty?

      # Check policies and select the first that passes
      select_by_policy(mappers, opts)
    end

    # Private: looks for an exact mapper object.
    #
    # site     - The Site to look into.
    # resource - The String containing the resource name filter.
    # action   - The String containing the action name filter.
    # key      - The String containing the key filter.
    # policy   - The String containing the policy class.
    #
    # Returns: the mapper object or nil if not found.
    #
    def self.find_exact_map(site, resource, action, key, policy)
      mapper = where(:site_id => site.id)
      mapper = mapper.where(:resource => resource)
      mapper = mapper.where(:action => action)
      mapper = mapper.where(:key => key.present? ? key : nil)
      mapper = mapper.where(:policy => policy.present? ? policy : nil)
      mapper.first
    end

    # Private: selects the first mapper that fulfills the policy
    #
    # mappers - The Array containing the mapper objects.
    # opts    - The Hash containing the policy filter data.
    #
    # Returns: the first matching mapper or nil if no one matches
    #
    def self.select_by_policy(mappers, opts)
      mappers.sort_by {|m| m.policy.to_s }.reverse.select {|m| m.send(:verify_policy, opts) }.first
    end

    # Private: checks the mapper policy against its class
    #
    # opts - The Hash containing the policy filter data.
    #
    # Return: true if it fulfills the policy and false if it does not.
    #
    def verify_policy(opts)
      result = policy.constantize.call(opts)
    rescue NameError
      result = true
    ensure
      return result
    end

    def self.check_policy_class(policy)
      klass = policy.constantize
      fail InvalidPolicyError.new(policy) unless klass.respond_to?(:call)
    end
  end
end
