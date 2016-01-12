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
    # Capturing the object file
    uploaded_io = params[:txt_file][:file]
    # writing the file to disk
    File.open(Rails.root.join('uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    # adding the filename and path to database
    filename = uploaded_io.original_filename
    path = Rails.root.join('uploads', uploaded_io.original_filename)
    @txt_file = TxtFile.new(:name => filename, :path => path)

    respond_to do |format|
      if @txt_file.save
        format.html { redirect_to @txt_file, notice: 'Txt file was successfully created.' }
        format.json { render :show, status: :created, location: @txt_file }

        # push all links in the database
        require "#{Rails.root}/app/fileReader.rb"
        reader = FileReader.new
        reader.readFile(@txt_file.path.to_s)
      else
        format.html { render :new }
        format.json { render json: @txt_file.errors, status: :unprocessable_entity }
      end
    end
  end

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
    #File.delete(@txt_file.path)
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
    params.require(:txt_file).permit(:file)
  end

end
