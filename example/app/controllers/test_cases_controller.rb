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
end
