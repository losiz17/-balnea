class HotelController < ApplicationController
  def index
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    params_1 = URI.encode_www_form({o_id: params[:id]})
  
    params_3 = URI.encode_www_form({count: '30'})
    params_4 = URI.encode_www_form({xml_ptn: '1'})
    
    # URIを解析し、hostやportをバラバラに取得できるようにする
    uri = URI.parse("http://jws.jalan.net/APIAdvance/HotelSearch/V1/?key=peg1690498d729&#{params_1}&#{params_3}&#{params_4}")
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
