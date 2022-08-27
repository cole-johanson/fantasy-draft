#' Clean names
#' 
#' Returns a vector the length of x with cleaned names. (Custom written for CBS
#' and ESPN data)
#' 
#' @param x a character vector
#' 
clean_names <- function(x) {
  x %>% 
    str_replace_all('\\n.*| QB .*| RB .*| K .*| TE .*| WR .*| D/ST','') %>% 
    str_replace_all('Q$|SSPD$|O$','') %>% 
    str_replace_all('\\.','') %>%  # A.J. Dillon vs AJ Dillon
    str_replace_all(' II{0,}$| Jr$','') # Allen Robinson II
}

#' Remove attempts
#' 
#' Returns a vector the length of x with FG attempts removed. (Custom written 
#' for ESPN data)
#' 
#' @param x a character vector
#' 
remove_attempts <- function(x) {
  x %>% 
    str_replace('/.*','') %>% 
    as.double
}

#' Get position
#' 
#' Returns a vector the length of x with the parsed position from a player's 
#' name
#' 
#' @param x a character vector
#' 
get_position <- function(x) {
  case_when(
    str_detect(x,'WR$| WR ')~'WR',
    str_detect(x,'RB$| RB ')~'RB',
    str_detect(x,'TE$| TE ')~'TE',
    str_detect(x,'D/ST$')~'DEF',
    str_detect(x,'QB$')~'QB',
    str_detect(x,'K$')~'K',
    TRUE~'Error'
  )
}
