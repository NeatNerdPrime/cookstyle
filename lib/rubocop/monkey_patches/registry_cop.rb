# frozen_string_literal: true
module RuboCop
  module Cop
    class Registry
      # we monkeypatch this warning to replace rubocop with cookstyle
      def print_department_missing_warning(name, path)
        message = "no department given for #{name}."
        message += ' Run `cookstyle -a --only Migration/DepartmentName` to fix.' if path.end_with?('.rb')
        emit_warning(path, message)
      end
    end
  end
end
