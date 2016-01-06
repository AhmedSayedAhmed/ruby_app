class TxtFilesController < ApplicationController
  before_action :set_txt_file, only: [:show, :edit, :update, :destroy]

  # GET /txt_files
  # GET /txt_files.json
  def index
    @txt_files = TxtFile.all
  end

  # GET /txt_files/1
  # GET /txt_files/1.json
  def show
  end

  # GET /txt_files/new
  def new
    @txt_file = TxtFile.new
  end

  # GET /txt_files/1/edit
  def edit
  end

  # POST /txt_files
  # POST /txt_files.json
  def create
    @txt_file = TxtFile.new(txt_file_params)

    respond_to do |format|
      if @txt_file.save
        format.html { redirect_to @txt_file, notice: 'Txt file was successfully created.' }
        format.json { render :show, status: :created, location: @txt_file }
      else
        format.html { render :new }
        format.json { render json: @txt_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /txt_files/1
  # PATCH/PUT /txt_files/1.json
  def update
    respond_to do |format|
      if @txt_file.update(txt_file_params)
        format.html { redirect_to @txt_file, notice: 'Txt file was successfully updated.' }
        format.json { render :show, status: :ok, location: @txt_file }
      else
        format.html { render :edit }
        format.json { render json: @txt_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /txt_files/1
  # DELETE /txt_files/1.json
  def destroy
    @txt_file.destroy
    respond_to do |format|
      format.html { redirect_to txt_files_url, notice: 'Txt file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_txt_file
      @txt_file = TxtFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def txt_file_params
      params.require(:txt_file).permit(:name, :path)
    end
end
