# frozen_string_literal: true
#
# Copyright:: 2020, Chef Software, Inc.
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module RuboCop
  module Cop
    module Chef
      module RedundantCode
        # Use the `:create_if_missing` action instead of `not_if` with a `::File.exist(FOO)` check.
        #
        # @example
        #
        #   #### incorrect
        #   cookbook_file '/logs/foo/error.log' do
        #     source 'error.log'
        #     owner 'root'
        #     group 'root'
        #     mode '0644'
        #     not_if { ::File.exists?('/logs/foo/error.log') }
        #   end
        #
        #   remote_file 'Download file' do
        #     path '/foo/bar'
        #     source 'https://foo.com/bar'
        #     owner 'root'
        #     group 'root'
        #     mode '0644'
        #     not_if { ::File.exist?('/foo/bar') }
        #   end
        #
        #   #### correct
        #   cookbook_file '/logs/foo/error.log' do
        #     source 'error.log'
        #     owner 'root'
        #     group 'root'
        #     mode '0644'
        #     action :create_if_missing
        #   end
        #
        #   remote_file 'Download file' do
        #     path '/foo/bar'
        #     source 'https://foo.com/bar'
        #     owner 'root'
        #     group 'root'
        #     mode '0644'
        #     action :create_if_missing
        #   end
        #
        class UseCreateIfMissing < Base
          include RuboCop::Chef::CookbookHelpers
          extend AutoCorrector

          MSG = 'Use the :create_if_missing action instead of not_if with a ::File.exist(FOO) check.'

          def_node_matcher :not_if_file_exist?, <<-PATTERN
          (block (send nil? :not_if) (args) (send (const {nil? (cbase)} :File) {:exist? :exists?} $(str ...)))
          PATTERN

          def_node_matcher :file_like_resource?, <<-PATTERN
          (block (send nil? {:cookbook_file :file :remote_directory :cron_d :remote_file :template} $str) ... )
          PATTERN

          def_node_search :create_action?, '(send nil? :action $sym)'

          def_node_search :path_property_node, '(send nil? :path $...)'

          def on_block(node)
            not_if_file_exist?(node) do |props|
              file_like_resource?(node.parent.parent) do |resource_blk_name|
                # the not_if file name is the same as the resource name or the value in the path property
                # and there's no action defined (it's the default)
                return unless (props == resource_blk_name || path_property_node(node.parent.parent)&.first&.first == props) &&
                              create_action?(node.parent.parent).nil?

                add_offense(node, message: MSG, severity: :refactor) do |corrector|
                  corrector.replace(node, 'action :create_if_missing')
                end
              end
            end
          end
        end
      end
    end
  end
end
