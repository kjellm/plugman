class Plugman
  class BlackWhitePolicy
    
    def initialize(black_list, white_list, &unknown_handler)
      @black           = black_list
      @white           = white_list
      @unknown_handler = unknown_handler
    end
    
    def apply(plugin_files)
      approved = []
      plugin_files.each do |plugin|
        if @white.include?(plugin)
          approved << plugin
          next
        end
        next if @black.include?(plugin)
        approved << plugin if @unknown_handler.call(plugin)
      end  
      approved
    end
    
  end
end