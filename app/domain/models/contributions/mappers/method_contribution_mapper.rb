# frozen_string_literal: true

module CodePraise
  module Mapper
    class MethodContributions
      def initialize(file_contributions)
        @file_contributions = file_contributions
      end

      def build_entity
        methods = all_methods

        return nil if methods.nil?

        methods.map do |method|
          Entity::MethodContribution.new(
            name: method_name(method[:name]),
            lines: method[:lines],
            complexity: method_complexity(method[:lines])
          )
        end
      end

      private

      def method_complexity(lines)
        ruby_code = lines.map(&:code).join("\n")
        complexity = abc_metric(ruby_code)
        complexity.average
      end

      def abc_metric(code)
        flog_reporter = CodePraise::Complexity::FlogReporter

        flog_reporter.flog_code(code) if code
      end

      def method_name(name)
        name.split('def').last.strip
      end

      def all_methods
        MethodParser.parse_methods(@file_contributions)
      end
    end
  end
end