# Yet another raylib wrapper for Ruby
#
# * https://github.com/vaiorabbit/raylib-bindings

require 'ffi'
require 'fileutils'
require_relative 'raylib_main'
require_relative 'config'
require_relative 'raymath'
require_relative 'rcamera'
require_relative 'rlgl'
require_relative 'raygui_main'
require_relative 'physac'
require_relative 'raylib_helper'
require_relative 'raygui_helper'

module Raylib
  extend FFI::Library

  def self.load_lib(libpath, raygui_libpath: nil, physac_libpath: nil, method_naming: :original)
    lib_paths = [libpath, raygui_libpath, physac_libpath].compact

    ffi_lib_flags :now, :global
    ffi_lib(*lib_paths)
    setup_symbols(method_naming: method_naming)

    setup_raygui_symbols(method_naming: method_naming) unless raygui_libpath.nil?
    setup_physac_symbols(method_naming: method_naming) unless physac_libpath.nil?
  rescue LoadError => e
    warn e
  end

  def self.setup_symbols(method_naming: :original)
    setup_raylib_symbols(method_naming: method_naming)
    setup_raymath_symbols(method_naming: method_naming)
    setup_rcamera_symbols(method_naming: method_naming)
    setup_rlgl_symbols(method_naming: method_naming)
  end

  #
  # Generate sample code
  #
  def self.template
    # Copy template code to user's current directory
    example_path = "#{Gem::Specification.find_by_name('raylib-bindings').full_gem_path}/examples"
    template_code_src = "#{example_path}/template.rb"
    unless File.exist? template_code_src
      warn "[Error] Raylib.template : Template source #{template_code_src} not found"
      return false
    end

    template_code_dst = "#{Dir.getwd}/template.rb"
    if File.exist? template_code_dst
      warn "[Error] Raylib.template : Template destination #{template_code_dst} already exists"
      return false
    end

    warn "[Info] Raylib.template : #{template_code_src} => #{template_code_dst}"
    FileUtils.copy template_code_src, template_code_dst
    warn '[Info] Raylib.template : Done'
  end
end
