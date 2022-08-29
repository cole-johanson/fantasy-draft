library(tidyverse)
source(here::here('src/functions.R'))

cbs_qb = read_csv(here::here('data/cbs_qb.csv'),show_col_types = F) %>%
  mutate(
    PLAYER = clean_names(PLAYER),
    source = 'CBS',
    position = 'QB'
  )
cbs_k = read_csv(here::here('data/cbs_k.csv'),show_col_types = F) %>%
  select(-XPA) %>%
  mutate(
    PLAYER = clean_names(PLAYER),
    source = 'CBS',
    position = 'K'
  )
cbs_te = read_csv(here::here('data/cbs_te.csv'),show_col_types = F) %>%
  mutate(
    position = 'TE',
    source = 'CBS',
    PLAYER = clean_names(PLAYER)
  )
cbs_wr = read_csv(here::here('data/cbs_wr.csv'),show_col_types = F) %>%
  mutate(
    position = 'WR',
    source = 'CBS',
    PLAYER = clean_names(PLAYER)
  )
cbs_rb = read_csv(here::here('data/cbs_rb.csv'),show_col_types = F) %>%
  mutate(
    position = 'RB',
    source = 'CBS',
    PLAYER = clean_names(PLAYER)
  )
cbs_def = read_csv(here::here('data/cbs_def.csv'),show_col_types = F) %>%
  mutate(
    position = 'DEF',
    source = 'CBS',
    PLAYER = clean_names(TEAM)
  ) %>% 
  select(-TEAM) %>%
  inner_join(
    # map "Buffalo" to "Bills"
    read_csv(here::here('data/map_team_name.csv'), show_col_types = FALSE),
    by=c("PLAYER"="CITY"),
  ) %>% 
  mutate(PLAYER = TEAM)
espn_flex = read_csv(here::here('data/espn_qb_flex.csv'),show_col_types = F) %>%
  mutate(
    position = get_position(PLAYER),
    source = 'ESPN',
    PLAYER = clean_names(PLAYER)
  ) %>% 
  filter(position %in% c('RB','WR','TE','QB'))
espn_def = read_csv(here::here('data/espn_def.csv'),show_col_types = F) %>%
  mutate(
    position = 'DEF',
    source = 'ESPN',
    PLAYER = clean_names(PLAYER)
  ) %>% 
  rename(
    FREC = FR
  )
espn_k = read_csv(here::here('data/espn_k.csv'),show_col_types = F) %>%
  filter(`FG39/FGA39` != '--/--') %>%
  mutate(
    position = 'K',
    source = 'ESPN',
    PLAYER = clean_names(PLAYER),
    `1-39` = remove_attempts(`FG39/FGA39`),
    `40-49` = remove_attempts(`FG49/FGA49`),
    `50+` = remove_attempts(`FG50+/FGA50+`),
    `XPM` = remove_attempts(`XP/XPA`)
  ) %>% select(-contains("/"))
fp = read_csv(here::here('data/fantasypros.csv'),show_col_types = F) %>% 
  mutate(
    position = NA_character_,
    source = 'Fantasy Pros',
    PLAYER = clean_names(`PLAYER NAME`)
  )

all_data = cbs_qb %>% 
  union_all(cbs_k) %>%
  union_all(cbs_te) %>%
  union_all(cbs_wr) %>%
  union_all(cbs_rb) %>%
  union_all(cbs_def) %>%
  union_all(espn_flex) %>%
  union_all(espn_def) %>%
  union_all(espn_k) %>% 
  union_all(fp) %>% 
  mutate_if(is.double,~coalesce(.,0)) %>% 
  group_by(PLAYER) %>% 
  filter(
    # Only take players with a record in each
    any(source=='ESPN') & any(source=='CBS') 
  ) %>% 
  mutate(
    # Fill in missing from FP
    position = max(position, na.rm=T)
  ) %>%
  mutate(
    fantasy_points = 
      PASSYDS*0.04 +
      PASSTD*4 + 
      INT*-1 +
      RUSHYDS*0.1 +
      RUSHTD*6 + 
      FL*-2 + # Fumbles lost
      RECYDS*0.1 +
      RECTD*6 + 
      `1-19`*3 + 
      `20-29`*3 +
      `30-39`*3 + 
      `1-39`*3 +
      `40-49`*4 + 
      `50+`*5 + 
      XPM*1 + 
      SFTY*2 +
      SCK*1 + 
      FREC*2 + # Fumble recovery
      ITD*6 + # Interception Return TD
      FTD*6 + # Fumble Return TD
      DTD*6 # Defensive Touchdowns (FTD + ITD)
  ) 

all_data_summarised = all_data %>%
  group_by(PLAYER, position) %>% 
  summarise(
    fantasy_points = mean(fantasy_points),
    .groups='drop'
  )
