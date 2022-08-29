all_data_plus_flex = all_data_summarised %>% 
  union_all(
    all_data_summarised %>% filter(position %in% c('RB','WR','TE')) %>% 
      mutate(position = 'FLEX')
  )

avg_starting_pts_by_position = all_data_plus_flex %>% 
  group_by(position) %>% 
  arrange(desc(fantasy_points)) %>% 
  filter(
    # likely to be drafted based on https://tinyurl.com/3s5ebpb4
    (position == 'QB' & row_number() <= 15) |
      (position == 'RB' & row_number() <= 54) |
      (position == 'WR' & row_number() <= 58) |
      (position == 'TE' & row_number() <= 12) |
      (position == 'DEF' & row_number() <= 10) |
      (position == 'K' & row_number() <= 10) |
      (position == 'FLEX' & row_number() <= 124) # 54+58+12
  ) %>% 
  summarise(
    avg_start_pts = mean(fantasy_points)
  )

value_vs_avg_starting = all_data_plus_flex %>% 
  inner_join(avg_starting_pts_by_position, by = "position") %>%
  mutate(
    value_diff = fantasy_points - avg_start_pts
  ) %>% 
  group_by(PLAYER) %>% 
  summarise(
    value_diff = max(value_diff)
  )

priorities = all_data_summarised %>% 
  left_join(value_vs_avg_starting, by="PLAYER") %>% 
  arrange(desc(value_diff)) 

kbl_priorities = priorities %>%
  mutate_if(is.double,~round(.,1)) %>%
  knitr::kable('html') %>% 
  kableExtra::kable_styling()