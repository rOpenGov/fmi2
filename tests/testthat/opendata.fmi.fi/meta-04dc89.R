structure(list(method = "GET", url = "https://opendata.fmi.fi/meta?observableProperty=observation&param=TG_PT12H_min&language=eng", 
    status_code = 200L, headers = structure(list(`Access-Control-Allow-Origin` = "*", 
        `Cache-Control` = "public, max-age=60", `Content-Length` = "855", 
        `Content-Type` = "text/xml; charset=UTF-8", Date = "Mon, 15 Jul 2024 12:43:04 GMT", 
        Expires = "Mon, 15 Jul 2024 12:44:04 GMT", `Last-Modified` = "Mon, 15 Jul 2024 12:43:04 GMT", 
        Server = "SmartMet Server (12:10:04 May 16 2024)", Vary = "Accept-Encoding", 
        Connection = "Keep-Alive"), class = "httr2_headers"), 
    body = charToRaw("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\n<ObservableProperty xmlns=\"http://inspire.ec.europa.eu/schemas/omop/2.9\"\n  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n  xmlns:gml=\"http://www.opengis.net/gml/3.2\"\n  xmlns:xlink=\"http://www.w3.org/1999/xlink\"\n  gml:id=\"tg_pt12h_min\"\n  xsi:schemaLocation=\"http://inspire.ec.europa.eu/schemas/omop/2.9 http://inspire.ec.europa.eu/draft-schemas/omop/2.9/ObservableProperties.xsd\">\n        <label>Ground minimum temperature</label>\n      \t<basePhenomenon>Temperature</basePhenomenon>\n      \t<uom uom=\"degC\"/>\n      \t<statisticalMeasure>     \n          <StatisticalMeasure gml:id=\"stat-min-PT12H-tg_pt12h_min---\">\n            <statisticalFunction>min</statisticalFunction><aggregationTimePeriod>PT12H</aggregationTimePeriod>\n          </StatisticalMeasure>\n        </statisticalMeasure>  </ObservableProperty>\n"), 
    cache = new.env(parent = emptyenv())), class = "httr2_response")
