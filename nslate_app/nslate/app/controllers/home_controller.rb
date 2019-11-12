class HomeController < ApplicationController
  require 'open-uri'
  def index
    if current_user.type == "CenterAdmin"
    response = open("http://localhost:3000/api/nslate/nslate_analytics/nslate_home?key=#{current_user.authentication_token}",:read_timeout => 300).read
    @final_quiz_data_page1 =  JSON.parse(response)["data"]
    #@final_quiz_data_page1 =  {"20-08-2016"=>{"published"=>[376, 2], "downloaded"=>[0, 0], "submitted"=>[1, 0], "not_submitted"=>[-1, 0]}}
    elsif current_user.type == "InstituteAdmin"
      response = open("http://localhost:3000/api/nslate/nslate_analytics/nslate_home_ia?key=#{current_user.authentication_token}",:read_timeout => 300).read
      @final_quiz_data_page1 =  JSON.parse(response)["data"]
    end
    respond_to do |format|
    format.html #index.html.haml
  end
  end
  def datewise_quiz
    @date = params[:date]
    present_user = current_user
    response = open("http://localhost:3000/api/nslate/nslate_analytics/datewise_quiz?key=#{current_user.authentication_token}&date=#{@date}",:read_timeout => 300).read
    @final_quiz_data_page2 =  JSON.parse(response)["data"]
    respond_to do |format|
      format.js { render partial: 'date_wise_quiz_data', :locals=>{:date=>@date,:data=>@final_quiz_data_page2} }
    end
  end
  def download_institute_wise_data_full
    @date = params[:date]
    response = open("http://localhost:3000/api/nslate/nslate_analytics/download_institute_wise_data_full?key=#{current_user.authentication_token}&date=#{@date}",:read_timeout => 300).read
    @final_quiz_data_page2 =  JSON.parse(response)["data"]
    csv_header1 =  "NGI Admission No,student id,downloaded student name,Center Name,Assessment Name".split(",")
    csv_header2 =  "NGI Admission No,student id,Not Submitted student name,Center Name,Assessment Name".split(",")
    csv_header3 =  "NGI Admission No,student id,submitted student name,Center Name,Assessment Name".split(",")
    file_name1 = Time.now.to_i.to_s+ "_" +(current_user.id).to_s + ".csv"
    csv_data1 = FasterCSV.generate do |csv|
      csv << csv_header1
      @final_quiz_data_page2["downloaded"].each do |row|
        csv << [row[1], row[2], row[3],row[4],row[5]]
      end
      csv << csv_header2
      @final_quiz_data_page2["not_submitted"].each do |row|
        csv << [row[1], row[2], row[3],row[4],row[5]]
      end
      csv << csv_header3
      @final_quiz_data_page2["submitted"].each do |row|
        csv << [row[1], row[2], row[3],row[4],row[5]]
      end
    end
    send_data csv_data1, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{file_name1}"

  end

  def download_datewise_quiz_data_full
    date = params[:date]
    response = open("http://localhost:3000/api/nslate/nslate_analytics/download_datewise_quiz_data_full?key=#{current_user.authentication_token}&date=#{date}",:read_timeout => 300).read
    @final_quiz_data_page2 =  JSON.parse(response)["data"]
    csv_header = "Date,Class_name,Assessment_name,not_submitted_User_name,rollno".split(",")
    file_name = Time.now.to_i.to_s+ "_" +(current_user.id).to_s+ ".csv"
    csv_data = FasterCSV.generate do |csv|
      csv << csv_header
      @final_quiz_data_page2.each do |p|
        a = []
        p.first[1].each do |k|
          k.first[1]["not_submitted"].each{ |l| a << [p.first[0],k.first[0].split("_").first,k.first[1]["quiz_name"],l[0],l[1]]} if k.first[1]["not_submitted"].size !=0

        end
        a.each{|c| csv << c} if a.size !=0
      end

    end
    send_data csv_data, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{file_name}"

  end
  def download_datewise_quiz_data
    date = params["date"]
    section_name = params["class"]
    quiz_name = params["quiz_name"]
    response =  open("http://localhost:3000/api/nslate/nslate_analytics/download_datewise_quiz_data?key=#{current_user.authentication_token}&date=#{date}").read
    @final_quiz_data_page2 =  JSON.parse(response)["data"]
    b = {date=>[]}
    @final_quiz_data_page2.map{|p| b[date] << p[date] }
    b[date] = b[date].flatten
    c = b[date].select{|k| k.first[0]==section_name}
    d = c.select{|k| k[section_name]["quiz_name"] == quiz_name}
    csv_header = "Date,Class_name,Assessment_name,not_submitted_User_name,rollno".split(",")
    file_name = Time.now.to_i.to_s+ "_" +date+"_"+section_name+"_"+quiz_name+ ".csv"
    csv_data = FasterCSV.generate do |csv|
      csv << csv_header
      #
      # a = []
      # b[0][section_name]["not_submitted"].each{ |l| a << [date,section_name.split("_").first,quiz_name,l[0],l[1]]}  if b[0][section_name]["not_submitted"].count !=0
      # a.each{|c| csv << c} if a.count !=0
      # p = []
      # @final_quiz_data_page2.first[date].each do |l|
      #   if l.first[0] == section_name
      #     p << l
      #   end
      # end
      a = []
      d[0][section_name]["not_submitted"].each{ |l| a << [date,section_name.split("_").first,quiz_name,l[0],l[1]]}  if d[0][section_name]["not_submitted"].count !=0
      a.each{|c| csv << c} if a.count !=0

    end
    send_data csv_data, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment; filename=#{file_name}"

  end
  def auth_token_getter
    client_id = "90f21cd17e768251dd6ad9b2c6b60fe14fd02f9f8353b97246bace3f230adf58"

    client_secret = "abfd10cf88cce16721d3a6891f50f9c99b4dccca9565958ee2c06258fdbc065f"

    redirect_uri = "http://localhost:5000/auth_token_getter"
    site = "http://localhost:3000"

    @p = "http://localhost:3000/oauth/authorize?client_id=90f21cd17e768251dd6ad9b2c6b60fe14fd02f9f8353b97246bace3f230adf58&redirect_uri=http%3A%2F%2Flocalhost%3A5000%2Fauth_token_getter&response_type=code"
  redirect_to @p

  end
  def auth_token_setter
    @code = params[:code]
  end
end

