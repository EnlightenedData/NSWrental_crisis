parse_rent_data = function(){
    load("./.RData") # this include sales from 2016 - 2022 and REA data

    rm(temp, conn)
    
    
    sfiles = list.files(#path = paste0(getwd(),"/Rentdata"), 
                        pattern = "rent.*\\d{4}.*\\.xlsx", ignore.case = T, full.names = T) 
    
    
    colnm = c("postcode", "dwt", "beds", "wklyrent_q1", "wklyrent_q2", 
              "wklyrent_q3", "bondnum", "rentchgqrt", "rentchgann", "bondchgqrt",
              "bondchgann")
    
    coltype = readr::cols(postcode = "c",
                        dwt = "c", 
                        bed = "c", 
                        wklyrent_q1 = "c", 
                        wklyrent_q2 = "c", 
                        wklyrent_q3 = "c", 
                        bondnum = "c", 
                        rentchgqrt = "c", 
                        rentchgann = "c", 
                        bondchgqrt = "c", 
                        bondchgann = "c")
    
    # now read these .dat files 
    sale_year <- purrr::map_df(sfiles, 
                               readxl::read_xlsx, 
                               col_names = colnm, 
                               #na = "-",
                               col_types = coltype,
                               skip = 9) 
    
    sales = bind_rows(nswvaluator, 
                      sale_year) %>% select((-X25)) %>% 
        distinct()
    rm(nswvaluator, sale_year)
    
    sales <- sales %>% 
        mutate(contract_dt = force_tz(as.Date(contractDate, "%Y%m%d"), tz = "Australia/Sydney"), 
               settle_dt = force_tz(as.Date(settlementDate, "%Y%m%d"), tz = "Australia/Sydney")) %>% 
        mutate(setyear = year(settle_dt), 
               conyear = year(contract_dt)) %>% 
        mutate(setmonth = floor_date(settle_dt, "1 month"), 
               setweek =  floor_date(settle_dt, "1 week"))
    
    return(list(sales, rea_res))
    
    }