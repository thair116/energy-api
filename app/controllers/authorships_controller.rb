class AuthorshipsController < ApplicationController
  before_action :set_authorship, only: [:show, :edit, :update, :destroy]

  # GET /authorships
  # GET /authorships.json
  def index
    @authorships = Authorship.all
  end

  # GET /authorships/1
  # GET /authorships/1.json
  def show
  end

  # GET /authorships/new
  def new
    @authorship = Authorship.new
  end

  # GET /authorships/1/edit
  def edit
  end

  # POST /authorships
  # POST /authorships.json
  def create
    @authorship = Authorship.new(authorship_params)

    respond_to do |format|
      if @authorship.save
        format.html { redirect_to @authorship, notice: 'Authorship was successfully created.' }
        format.json { render action: 'show', status: :created, location: @authorship }
      else
        format.html { render action: 'new' }
        format.json { render json: @authorship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authorships/1
  # PATCH/PUT /authorships/1.json
  def update
    respond_to do |format|
      if @authorship.update(authorship_params)
        format.html { redirect_to @authorship, notice: 'Authorship was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @authorship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorships/1
  # DELETE /authorships/1.json
  def destroy
    @authorship.destroy
    respond_to do |format|
      format.html { redirect_to authorships_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authorship
      @authorship = Authorship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authorship_params
      params.require(:authorship).permit(:article_id, :author_id)
    end
end
