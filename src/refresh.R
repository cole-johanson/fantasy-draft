fantasy_data_url = "https://docs.google.com/spreadsheets/d/1NsQ4M1qzoppUo0XP91rpF-rszdlaZpSIvV11SAZi7vA/edit#gid=1992290280"
# Using csv files so they're easier to read for non-R users
googlesheets4::read_sheet(fantasy_data_url,sheet="CBS QB") %>% 
  write_csv('data/cbs_qb.csv')
googlesheets4::read_sheet(fantasy_data_url,sheet="CBS K") %>% 
  write_csv('data/cbs_k.csv')
googlesheets4::read_sheet(fantasy_data_url,sheet="CBS TE") %>% 
  write_csv('data/cbs_te.csv')
googlesheets4::read_sheet(fantasy_data_url,sheet="CBS WR") %>% 
  write_csv('data/cbs_wr.csv')
googlesheets4::read_sheet(fantasy_data_url,sheet="CBS RB") %>% 
  write_csv('data/cbs_rb.csv')
googlesheets4::read_sheet(fantasy_data_url,sheet="CBS DST") %>% 
  write_csv('data/cbs_def.csv')
googlesheets4::read_sheet(fantasy_data_url,sheet="ESPN QB + Flex") %>% 
  write_csv('data/espn_qb_flex.csv')
googlesheets4::read_sheet(fantasy_data_url,sheet="ESPN Defense") %>% 
  write_csv('data/espn_def.csv')
googlesheets4::read_sheet(fantasy_data_url,sheet="ESPN Kickers",col_types="??ccccc") %>% 
  write_csv('data/espn_k.csv')