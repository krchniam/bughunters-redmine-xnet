module ChartsEnumerationPatch

  def self.included(base)
    unless Enumeration.respond_to? :values
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
      end
    end
  end

  module ClassMethods
  
    def values(option)
      get_values(option)
    end

  end

  module InstanceMethods
  end

end