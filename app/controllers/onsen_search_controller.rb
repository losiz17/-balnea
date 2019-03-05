require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'
require 'open-uri' 
require 'open_uri_redirections'

class OnsenSearchController < ApplicationController
  def index
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    params_1 = URI.encode_www_form({onsen_q: params[:onsen_q]})
    params_2 = URI.encode_www_form({pref: params[:pref]})
    params_3 = URI.encode_www_form({count: '30'})
    params_4 = URI.encode_www_form({xml_ptn: '1'})
    
    # URIを解析し、hostやportをバラバラに取得できるようにする
    uri = URI.parse("http://jws.jalan.net/APICommon/OnsenSearch/V1/?key=peg1690498d729&#{params_1}&#{params_2}&#{params_3}&#{params_4}")

    # リクエストパラメタを、インスタンス変数に格納
    @query = uri.query

    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      # 接続時に待つ最大秒数を設定
      http.open_timeout = 15
      # 読み込み一回でブロックして良い最大秒数を設定
      http.read_timeout = 100
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(uri.request_uri)
    end


    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        
        @result = Hash.from_xml(response.body).to_json
        @result = JSON.parse(@result)
         
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end


      # エラー時処理
      rescue IOError => e
        @message = "e.message"
      rescue TimeoutError => e
        @message = "e.message"
      rescue JSON::ParserError => e
        @message = "e.message"
      rescue => e
        @message = "e.message"
    end
  end




# 詳細画面
  def show
    
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    params_1 = URI.encode_www_form({onsen_q: params[:onsen_q]})
    params_2 = URI.encode_www_form({pref: params[:pref]})
    params_3 = URI.encode_www_form({count: '1'})
    params_4 = URI.encode_www_form({start: params[:id]})
    params_5 = URI.encode_www_form({xml_ptn: '1'})
    
    # URIを解析し、hostやportをバラバラに取得できるようにする
    uri = URI.parse("http://jws.jalan.net/APICommon/OnsenSearch/V1/?key=peg1690498d729&#{params_1}&#{params_2}&#{params_3}&#{params_4}&#{params_5}")
    p uri
    # リクエストパラメタを、インスタンス変数に格納
    @query = uri.query

    # 新しくHTTPセッションを開始し、結果をresponseへ格納
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      # 接続時に待つ最大秒数を設定
      http.open_timeout = 15
      # 読み込み一回でブロックして良い最大秒数を設定
      http.read_timeout = 100
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(uri.request_uri)
    end


    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # responseのbody要素をJSON形式で解釈し、hashに変換
        
        @result = Hash.from_xml(response.body).to_json
        @result = JSON.parse(@result)
        # 表示用の変数に結果を格納
        @name = @result["Results"]["Onsen"]["OnsenName"]
        @SmallArea = @result["Results"]["Onsen"]["Area"]["SmallArea"]
        @NatureOfOnsen = @result["Results"]["Onsen"]["NatureOfOnsen"]
        @OnsenAreaCaption = @result["Results"]["Onsen"]["OnsenAreaCaption"]
        @OnsenID = @result["Results"]["Onsen"]["OnsenID"]
        p @OnsenID.to_s
        @samples = Sample.where(onsenid: @OnsenID).order(params[:sort])
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end


      # エラー時処理
      rescue IOError => e
        @message = "e.message"
      rescue TimeoutError => e
        @message = "e.message"
      rescue JSON::ParserError => e
        @message = "e.message"
      rescue => e
        @message = "e.message"
    end
  end
    
end
