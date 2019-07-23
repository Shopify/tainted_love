# frozen_string_literal: true

class TestCasesController < ApplicationController
  layout false

  def xss
  end

  def unsafe_render
    render(params[:file])
  end

  def render_inline
    render(inline: params[:template])
  end

  def unsafe_redirect
    redirect_to(params[:to])
  end

  def taint_test
    cookies[:something] = 'asdf'

    values = {
      'route_parameter_value' => params[:route_param],
      'get_parameter' => params[:get_param],
      'get_array_parameter_0' => params[:get_array_param][0],
      'get_array_parameter_1' => params[:get_array_param][1],
      'parameter_name' => params.keys.first,
      'header_value' => request.headers['Host'],
      'header_name' => request.headers.to_h.keys.select { |k| k['HTTP_AAA'] }.first,
      'cookie_value' => cookies[:something],
      'cookie_name' => cookies.to_h.keys.first,
      'fullpath' => request.original_fullpath
    }

    description = values.keys
    tainted = values.values.map(&:tainted?)
    sources = values.values.map(&:tainted_love_tags)

    render json: description.zip(values.values, tainted, sources)
  end
end
