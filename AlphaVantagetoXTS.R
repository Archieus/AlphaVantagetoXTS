library(quantmod)

#alphavantage API = 4FS12H08TP68SJV2

symbol <- "OAKBX"
DataType <- "EQ" #CR=Crypto, EQ=Equity/Mutual Fund

####Download ADJUSTED PRICE DATA from AlphaVantage
###outputsize=c(full,compact) full= 20 years of data, compact = 100 datapoints

#https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_DAILY&symbol=BTC&market=CNY&apikey=demo&datatype=csv

#### CREATE COMPONENTS FOR EQUIY & MUTUAL FUNDS API CALL ####
apikey <- "&outputsize=full&apikey=4FS12H08TP68SJV2&datatype=csv"
URLbase <- "http://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol="

#### CREATE COMPONENTS FOR CRYPTO CURRENCY API CALL ####
Cryptokey <- "&market=USD&apikey=4FS12H08TP68SJV2&datatype=csv"
Cryptobase <-"https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_DAILY&symbol="

cu <-NULL
ru <-NULL

dataenv <- new.env()
if(DataType =="EQ") {
  cu <- paste0(URLbase, symbol)
  ru <- paste0(cu, apikey)
  assign(paste0(symbol, ".z"), read.zoo(ru, header = TRUE, sep = ","), env = dataenv)
}else{
  cu <- paste0(Cryptobase, symbol)
  ru <- paste0(cu,Cryptokey)
  assign(paste0(symbol, ".z"), read.zoo(ru, header = TRUE, sep = ","), env = dataenv)
}


### Extract Open, High, Low, Close, Volume, Adjusted Close (Quantmod format) ###
if(DataType =="EQ") {
  assign(paste(symbol), as.xts(cbind(get(as.character(ls(dataenv)), envir = dataenv)$open,
                                                     get(as.character(ls(dataenv)), envir = dataenv)$high,
                                                     get(as.character(ls(dataenv)), envir = dataenv)$low,
                                                     get(as.character(ls(dataenv)), envir = dataenv)$close,
                                                     get(as.character(ls(dataenv)), envir = dataenv)$volume,
                                                     get(as.character(ls(dataenv)), envir = dataenv)$adjusted_close)))
}else {
  assign(paste(symbol), as.xts(cbind(get(as.character(ls(dataenv)), envir = dataenv)$open..USD.,
                                                     get(as.character(ls(dataenv)), envir = dataenv)$high..USD.,
                                                     get(as.character(ls(dataenv)), envir = dataenv)$low..USD.,
                                                     get(as.character(ls(dataenv)), envir = dataenv)$close..USD.)))
}
