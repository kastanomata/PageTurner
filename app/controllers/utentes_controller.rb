class UtentesController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
before_action :set_utente, only: %i[ show edit update destroy ]

  def index
    @utentes = Utente.all
  end

  def show
  end

  def new 
    @utente = Utente.new
  end

  def create
    @utente = Utente.new(utente_params)
    if @utente.save
      redirect_to utentes_path
    else 
      render :new, status: :unprocessable_entity
    end
  end

  def edit 
  end 

  def update
    if @utente.update(utente_params)
      redirect_to @utente
    else 
      render :edit, status: unprocessable_entity
    end
  end

  def destroy
    @utente.destroy
    redirect_to utentes_path
  end

  private
    def set_utente
      @utente = Utente.find(params[:id])
    end


  private 
  def utente_params
    params.expect(utente: [ :nome, :email ])
  end
end
