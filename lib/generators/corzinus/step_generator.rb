module Corzinus
  class StepGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :step_name, required: true
    argument :step_position, required: true

    desc <<-DESC.strip_heredoc
    ----------------------------------------------------------------------------
    Creates a new Corzinus step
    ----------------------------------------------------------------------------

    STEP_POSITION can be from 0 to last step index. But we recommend adding
    it before complete or confirm step. You can do this by STEP_POSITION alias:
    first   --> Add your STEP_NAME to first position in checkout_steps
    default --> Add your STEP_NAME before confirm step in checkout_steps

    ----------------------------------------------------------------------------

    rails g corzinus:step STEP_NAME STEP_POSITION

    ----------------------------------------------------------------------------

    This will add to checkouts_steps STEP_NAME on STEP_POSITION in your corzinus
    initializer

    This will create:
    service for step's access --> app/services/corzinus/checkout/STEP_NAME_access_service.rb
    command for step's action --> app/commands/corzinus/checkout/STEP_NAME_step.rb
    view for step             --> app/views/corzinus/checkouts/STEP_NAME.html.haml

    DESC

    def add_to_checkout_steps
      steps = new_checkout_steps(current_steps)
      gsub_file initializer_path, /config.checkout_steps.*/ do
        "config.checkout_steps = #{steps}"
      end
    end

    def add_step_service
      @step_class = step_name.underscore.camelize
      template 'generate_step/access_service.rb', "app/services/corzinus/checkout/#{step_name.underscore}_access_service.rb"
    end

    def add_step_command
      @step_name = step_name.underscore
      @step_class = @step_name.camelize
      template 'generate_step/command_step.rb', "app/commands/corzinus/checkout/#{step_name.underscore}_step.rb"
    end

    def add_step_view
      @step_class = step_name.underscore.camelize
      template 'generate_step/step.html.haml', "app/views/corzinus/checkouts/#{step_name.underscore}.html.haml"
    end

    private

    def new_checkout_steps(steps)
      case step_position
      when 'default' then steps.insert(-3, step_name.to_sym)
      when 'first' then steps.unshift(step_name.to_sym)
      else steps.insert(step_position.to_i, step_name.to_sym)
      end
    end

    def current_steps
      step_string = initializer_file.grep(/config.checkout_steps/).first
      raise 'BlankCorzinusInitializer' if step_string.blank?
      steps = eval(step_string.scan(/\[.*\]/).first)
      raise 'LargePositionForSteps' if step_position.to_i > steps.size
      steps
    end

    def initializer_file
      File.readlines(initializer_path)
    end

    def initializer_path
      'config/initializers/corzinus.rb'
    end
  end
end
