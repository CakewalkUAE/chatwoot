class Captain::ToolRegistryService
  attr_reader :registered_tools, :tools

  def initialize(assistant)
    @assistant = assistant
    @registered_tools = []
    @tools = {}
  end

  def register_tool(tool_class)
    tool = tool_class.new(@assistant)
    return unless tool.active?

    @tools[tool.name] = tool
    @registered_tools << tool.to_registry_format
  end

  def method_missing(method_name, *arguments)
    if @tools.key?(method_name.to_s)
      @tools[method_name.to_s].execute(*arguments)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @tools.key?(method_name.to_s) || super
  end
end
