SELECT DISTINCT
		 a.leads_created_time as leads_created_time,
		 a.created_time as crm_created_time,
		 case
				 when lower(a.lead_source_detail_blended)  LIKE '%manual%update%' THEN DATE(a.created_time)
				 else null
			 end previous_created_time,
		 a.registered_time as registered_time,
		 a.latest_nurturing_date as latest_nurturing_date,
		 date(a.modified_time) modified_time,
		 a.modified_time as modified_timestamp,
		 date(a.leads_created_time) as leads_created_date,
		 date_format(a.leads_created_time, '%m-%d') leads_created_date_month,
		 date_format(a.leads_created_time, '%Y-%m') leads_created_month_year,
		 date_format(a.leads_created_time, '%m') leads_created_month_of_year,
		 date_format(a.leads_created_time, '%d') leads_created_day_of_month,
		 case
				 when a.created_time  is not null
				 AND	a.registered_time  is not null
				 AND	date(a.created_time)  <> date(a.registered_time) then 'Y'
				 else 'N'
			 end re_sync_flag,
		 COALESCE(a.talenta_name, '-') as deal_name,
		 trim(replace(replace(replace(replace(replace(replace(lower(a.talenta_name), '.', ' '), 'cv ', ''), 'pt ', ''), ' cv', ''), ' pt', ''), 'tbk', ''))  "company_name_cleansed",
		 COALESCE(a.company_id, 0) as company_id,
		 COALESCE(a.demo_company_id, 0) as demo_company_id,
		 COALESCE(a.pic_name_hrd, '-') as pic_name_hrd,
		 COALESCE(a.pic_phone_hrd, '-') as pic_phone_hrd,
		 COALESCE(a.is_part_of_holding_group, '-') as is_part_of_holding_group,
		 COALESCE(a.holding_group_name, '-') as holding_group_name,
		 COALESCE(a.current_system_integrator, '-') as current_system_integrator,
		 COALESCE(a.platform_revenue, '-') as platform_revenue,
		 COALESCE(SUBSTR(a.pic_phone_hrd,1, 2), '-') phone_prefix,
		 coalesce(a.pic_email_hrd, a.email, '-') email,
		 COALESCE(lower(substr(a.email, strpos(a.email, '@')-length(a.email),length(a.email) -strpos(a.email, '@'))),'-') email_suffix,
		 COALESCE(a.lead_origin,'-') as lead_origin,
		 case
				 when lower(a.lead_medium_blended)  in ( 'website - chat wa'  )
				 OR	lower(a.lead_source_detail_blended)  like '[%' then 'waba'
				 when lower(a.form_name_blended)  like '%trial%'
				 OR	lower(a.form_name_blended)  = 'web sign up (non-inquiry)' then 'web trial'
				 when lower(a.form_name_blended)  like '%inquiry%' then 'inquiry form'
				 else 'others'
			 end lead_type,
		 case
				 when a.demo_company_id  is not null
				 OR	lower(a.form_name)  = 'web sign up (non-inquiry)' then 'demo sign up'
				 when lower(a.lead_medium_blended)  in ( 'website - chat wa'  ) then 'waba'
				 else coalesce(a.lead_sub_type, case
						 when a.form_name_blended  is not null then 'form'
						 else '-'
					 end)
			 end lead_sub_type,
		 a.lead_channel lead_channel,
		 coalesce(a.lead_source_blended, '(empty)') as lead_source,
		 coalesce(a.lead_medium_blended, '(empty)') as lead_medium,
		 COALESCE(a.lead_source_detail_blended,'-') as lead_source_detail,
		 case
				 when l.short  is not null then l.matchtype
				 when n.short  is not null then n.matchtype
				 when a.lead_source_detail_blended  like '%@%~%' then split_part(split_part(split_part(a.lead_source_detail_blended, '@ ',2), '~',1), '|',1)
				 else '-'
			 end keyword_match_type,
		 case
				 when m.key  is not null then m.manual_keyword
				 when l.short  is not null then l.utm_term
				 when n.short  is not null then n.utm_term
				 when a.lead_source_detail_blended  like '%@%~%' then split_part(split_part(split_part(a.lead_source_detail_blended, '@ ',2), '~',1), '|', 2)
				 else '-'
			 end keyword,
		 case 
				 when a.lead_medium_blended  like '%chat wa%'
				 OR	a.lead_sub_type  in ( 'waba'  ) then coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_)
				 when a.lead_source_detail_blended  like '%@%~%' then split_part(a.lead_source_detail_blended, ' @',1)
				 when a.lead_source_detail_blended  like '%~%'
				 AND	a.lead_source_detail_blended  not like '~%' then rtrim(split_part(a.lead_source_detail_blended, '~',1))
				 when lower(a.lead_source_detail_blended)  = 'drop mql klikpajak' then a.lead_source_detail_blended
				 when a.lead_source_detail_blended  like '~%'
				 OR	coalesce(a.lead_source_detail_blended, '-')  not like '%|%' then null
				 when a.lead_source_detail_blended  like '%~%' then rtrim(split_part(a.lead_source_detail_blended, '~',1))
				 else COALESCE(a.lead_source_detail_blended,'-')
			 end utm_campaign,
		 case
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  not like '%(o)%'
				 AND	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  not in ( 'social media - yt'  )
				 AND	(lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%youtube%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%yt%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '% yt%') then 'G. YouTube'
				 when lower(coalesce(a.lead_source_detail_blended, '-'))  like '%discover%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%gmail%' then 'G. Discovery'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%display%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%gdn%' then 'G. Display'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'fb'  , 'ig'  )
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%fb%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%facebook%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%fb%' then 'FB/IG'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%influencer%' then 'Influencer'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%tw%' then 'Twitter'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '% li'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like 'li %'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  = 'li'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%linkedin%' then 'LinkedIn'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%pos%indo%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  = 'mail' then 'Pos Indo'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  = 'tt' then 'TikTok'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  = 'performance max' then 'Performance Max'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'google search'  , 'google ads - search'  , '(i) google ads - search'  , 'google - search'  )
				 OR	lower(a.lead_source_blended)  in ( 'search ads'  )
				 OR	(coalesce(b.lead_medium, a.lead_medium_blended, '-')  = '(empty)'
				 AND	(length(a.gclid)  > 5
				 OR	length(a.mkt_gclid)  > 5
				 OR	length(a.lead_channel)  >= 15)) then 'G. Search ads' /*edit by Agnes*/
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'bing'  ) then 'B. Search ads' /*edit by Agnes*/
				 else '-'
			 end ads_spending_type,
		 coalesce(a.latest_lead_source, '(empty)') latest_lead_source,
		 coalesce(a.latest_lead_medium, '(empty)') latest_lead_medium,
		 COALESCE(a.latest_lead_source_detail,'-') latest_lead_source_detail,
		 -- '' as is_multi_product,
		 replace(f.urls, 'https://www.talenta.co', '') as landing_page,
		 f.page_type as landing_page_type,
		 replace(g.urls, 'https://www.talenta.co', '') as goal_previous_step_2,
		 g.page_type as goal_previous_step_2_type,
		 replace(h.urls, 'https://www.talenta.co', '') as goal_previous_step_1,
		 h.page_type as  goal_previous_step_1_type,
		 replace(coalesce(i.urls, coalesce(c.urls, case
				 when lower(coalesce(a.lead_source_detail_blended, '-'))  like '%(d%' then '/demo.talenta.co/'
				 else null
			 end)), 'https://www.talenta.co', '') as completion_location,
		 coalesce(i.page_type, c.page_type) as completion_location_type, 
		 replace((coalesce( f.urls, c.urls, a.waba_utm_medium, (
			case
				 when lower(a.lead_source_sales_blended)  like '%inquir%' then (
					case
						 when lower(a.lead_source_detail_blended)  like '%chat%'
						 AND	lower(split_part(split_part(a.lead_source_detail_blended, '(',2), ')',1))  in ( 'w1'  , 'w2'  , 'w3'  , 'w4'  , 'w5'  , 'w6'  , 'w7'  , 'm1'  , 'm2'  , 'm3'  , 'm4'  , 'm5'  , 'm6'  , 'm7'  ) then 'chat button'
						 when lower(a.lead_medium_blended)  like '%chat%' then 'chat sticky'
						 when lower(a.lead_medium_blended)  like '%call%' then 'call'
						 when lower(a.lead_sub_type)  like '%lead%gen%' then 'lead gen'
						 when a.lead_sub_type  is not null then lower(a.lead_sub_type)
						 when length(a.form_name_blended)  > 4 then 'form'
						 when lower(a.lead_medium_blended)  is not null then lower(a.lead_medium_blended)
						 else 'others'
					 end)
				 else (
					case
						 when lower(a.lead_source_detail_blended)  like '%self%purchase%'
						 OR	lower(a.lead_source_detail_blended)  like '%tokyo%'
						 OR	lower(a.lead_source_detail_blended)  like '%social%media%organic%'
						 OR	lower(a.lead_source_detail_blended)  like '% ebook %'
						 OR	lower(a.lead_source_detail_blended)  like '%mekari.com%' then lower(a.lead_source_detail_blended)
						 else coalesce(lower(a.lead_medium_blended), '- undefined -')
					 end)
			 end))), 'https://www.talenta.co', '') landing_leading_page,
		  case
				 when coalesce(f.urls, c.urls)  like '%/blog%' then 'Blog'
				 when coalesce(f.urls, c.urls)  like '%/%' then 'Product'
				 else '-undefined-'
			 end as landing_leading_page_type, 
		 /* ------ Additional WABA Details ------ */ a.channel_code as channel_code,
		 COALESCE(a.campaign_code,'-') as campaign_code,
		 coalesce(l.first_journey_page, a.post_id, '-') post_id,
		 coalesce(case
				 when lower(a.device_code)  like '%w%' then 'W'
				 when lower(a.device_code)  like '%m%' then 'M'
				 else '-'
			 end, '(undefined)') device_code,
		 coalesce(a.waba_utm_medium, b.lead_medium,'-') waba_utm_medium,
		 coalesce(c.urls, case
				 when lower(coalesce(a.lead_source_detail_blended, '-'))  like '%(d%' then 'https://demo.talenta.co/'
				 else null
			 end) as  waba_leading_page,
		 c.page_type as waba_leading_page_category,
		 coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_)  as waba_campaign_name,
		 case
				 when COALESCE(j.campaign_name, d.campaign_name__t_)  is not null then 'Direct'
				 when (coalesce(c.urls, a.post_id)  is not null
				 AND	lower(coalesce(a.lead_source_detail_blended, '-'))  like '[%')
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%(d%' then 'Website Click'
				 else null
			 end  as waba_source,
		 case
				 when l.short  is not null then l.device
				 when n.short  is not null then n.device
				 when lower(split_part(split_part(a.lead_source_detail_blended, '(',2), ')',1))  like '%w%' then 'Desktop'
				 when lower(split_part(split_part(a.lead_source_detail_blended, '(',2), ')',1))  like '%m%' then 'Mobile'
				 else null
			 end  as waba_device_type,
		 '-' as initial_chat_type,
		 '-' as initial_chat_details,
		 /* ------ End of Additional WABA Details ------ */ a.form_name_blended as form_name,
		 COALESCE(a.latest_form_name,'-') as latest_form_name,
		 COALESCE(a.complementary_product,'-') complementary_product,
		 case
				 when a.first_lead_status_updated  is null then (
					case
						 when a.sales_meeting_date  is not null
						 AND	a.sales_meeting_date  >= current_date then a.leads_created_time
						 when a.sales_meeting_date  is not null
						 AND	a.sales_meeting_date  < current_date then a.sales_meeting_date
						 else a.leads_created_time
					 end)
				 else a.first_lead_status_updated
			 end first_lead_status_updated,
		 a.last_lead_status_updated as last_lead_status_updated,
		 a.first_lead_status_updated as crm_first_lead_status_updated,
		 0 as raw_to_mql_duration_hour,
		 date_diff('day', case
				 when a.is_recycle  = 'No' then a.created_time
				 else a.leads_created_time
			 end, case
				 when a.first_lead_status_updated  is null then (
					case
						 when a.sales_meeting_date  is not null then a.sales_meeting_date
						 else a.leads_created_time
					 end)
				 else a.first_lead_status_updated
			 end) raw_to_mql_duration_day,
		 coalesce(a.lead_status,'-') as lead_status,
		 coalesce(a.lead_result,'-') as lead_result,
		 COALESCE(replace(lower(coalesce(a.lead_result, a.lead_status)), 'lost lead - ', ''),'-') as status_result,
		 case
				 when a.lead_medium_blended  like '% - %'
				 OR	a.lead_medium_blended  = a.lead_source_blended then a.lead_medium_blended
				 else coalesce(lower(a.lead_source_blended), '-') || ' / ' || coalesce(lower(a.lead_medium_blended), '-')
			 end lead_source_medium,
		case
				 when a.lead_source_sales_blended  in ( 'Inbound - Marketing Digital Trial'  , 'Inbound - Marketing Digital Web Demo'  , 'Inbound - Web Demo'  ) THEN 'Web Demo'
				 when (a.lead_source_sales_blended  = 'Inbound - Marketing Digital Inquiries'
				 AND	lower(coalesce(a.lead_medium_blended, '-'))  not like '%email%')
				 OR	a.lead_source_sales_blended  in ( 'Inbound - Marketing Digital Web Inquiries'  , 'Inbound - Web Inquiries'  ) THEN 'Web Inquiries'
				 when lower(a.lead_source_sales_blended)  like 'inbound%channel%' THEN 'P. Channel'
				 when a.lead_source_sales_blended  in ( 'Referral - Program'  , 'Inbound - Referral'  ) THEN 'Referral'
				 when a.lead_source_sales_blended  in ( 'Inbound - Marketing Offline'  , 'Inbound - Offline'  , 'Inbound - Event'  ) THEN 'Event'
				 when a.lead_source_sales_blended  in ( 'Inbound - Marketing Digital Social Media'  , 'Inbound - Social Media'  ) THEN 'Social Media'
				 when a.lead_source_sales_blended  in ( 'Inbound - Marketing Digital Ebook'  , 'Inbound - Ebook'  ) THEN 'E-Book'
				 when (a.lead_source_sales_blended  = 'Inbound - Marketing Digital Inquiries'
				 AND	lower(a.lead_medium_blended)  like '%email%')
				 OR	a.lead_source_sales_blended  in ( 'Inbound - Marketing Digital Email Inquiries'  , 'Inbound - Email Inquiries'  ) THEN 'Email Inquiries'
				 when a.lead_source_sales_blended  in ( 'Inbound - Marketing Digital Ecosystem'  , 'Inbound - Ecosystem'  , 'Cross Sell Jurnal - Inbound'  ) THEN 'Ecosystem'
				 when a.lead_source_sales_blended  in ( 'Inbound - Channel'  ) THEN 'Channel'
				 else 'Others (Non-MKT)'
			 end lead_source_sales,
		 COALESCE(a.lead_source_sales_blended,'-') as lead_source_sales_full_name,
		 case
				 when lower(a.lead_source_blended)  not like '%sales%'
				 AND	lower(a.lead_medium_blended)  not like '%sales%'
				 AND	lower(a.lead_source_blended)  not like '%sdr%'
				 AND	lower(a.lead_source_blended)  <> 'p. channel'
				 AND	(lower(a.lead_source_blended)  like '%referral%'
				 OR	lower(a.lead_medium_blended)  like '%referral%'
				 OR	lower(a.lead_source_sales_blended)  like '%referral%'
				 OR	a.referral_code  is not null) THEN 'Referral'
				 when lower(a.lead_source_blended)  like '%referral%sales%'
				 AND	a.referral_code  is not null then 'Outbound'
				 when a.lead_source_detail_blended  like '%-53459]%'
				 AND	lower(a.lead_medium_blended)  = 'website - chat wa' then 'Outbound'
				 when coalesce(a.payment_closing_date, a.sales_meeting_date, a.tele_assign_date, a.first_lead_status_updated, a.leads_created_time)  >= date('2023-01-01')
				 AND	lower(a.lead_source_blended)  = 'p. channel' THEN 'Outbound'
				 when coalesce(a.payment_closing_date, a.sales_meeting_date, a.tele_assign_date, a.first_lead_status_updated, a.leads_created_time)  <= date('2022-12-31')
				 AND	lower(a.lead_source_sales_blended)  = 'inbound - channel'
				 AND	lower(a.lead_source_blended)  = 'p. channel' THEN 'Outbound'
				 when a.lead_source_blended  like 'outbound%'
				 OR	a.lead_source_blended  like 'SDR' then 'Outbound'
				 when lower(a.lead_source_sales_blended)  like 'inbound%'
				 AND	lower(a.lead_source_sales_blended)  NOT like '%sales%'
				 AND	lower(a.lead_source_sales_blended)  NOT like '%referral%' THEN 'Inbound'
				 else 'Outbound'
			 end inbound_outbound,
		 case
				 when a.referral_code  is null then 'No'
				 else 'Yes'
			 end is_referral_code,
		 case
				 when a.leads_created_time  < date('2023-01-01')
				 AND	lower(a.lead_source_sales_blended)  like '%inbound%channel%'
				 OR	(a.leads_created_time  < date('2023-01-01')
				 AND	lower(a.lead_source_blended)  like '%p.%channel%')
				 OR	(a.leads_created_time  < date('2023-01-01')
				 AND	a.lead_source_detail_blended  like '%-76690]%'
				 AND	lower(a.lead_medium_blended)  = 'website - chat wa') /*added by agnes, 10-oct'22*/
				 OR	(a.leads_created_time  < date('2023-01-01')
				 AND	a.lead_source_detail_blended  like '%-52095]%'
				 AND	lower(a.lead_medium_blended)  = 'website - chat wa')
				 OR	(a.leads_created_time  < date('2023-01-01')
				 AND	a.lead_source_detail_blended  like '%-53459]%'
				 AND	lower(a.lead_medium_blended)  = 'website - chat wa') then 'P. Channel' /* added by donner, 10-sep'22*/
				 when a.leads_created_time  >= date('2022-03-01')
				 AND	(lower(a.form_name)  = 'community - inquiry form'
				 OR	lower(a.lead_medium_blended)  in ( 'hosting'  , 'tap in'  , 'tap-in'  )) then 'P. Community' /* end of  Community Partnership */
				 when a.leads_created_time  >= date('2022-09-01')
				 AND	a.leads_created_time  < date('2023-01-01')
				 AND	((split_part(split_part(replace(a.lead_source_detail_blended, ' ', ''), '-',2), ']',1)  in ( '52095'  , '53459'  , '76690'  )
				 AND	coalesce(a.waba_utm_medium, b.lead_medium,'-')  is null)
				 OR	lower(a.lead_source_detail_blended)  in ( 'dgtraffic'  , 'docotel'  , 'elevenia'  , 'melvi'  , 'partner beonextalenta 160222'  , 'visiintech'  , 'nurosoft'  , 'adminku consulting'  , 'perkom'  , 'anduin'  , 'grace consultant'  , 'humanindo'  , 'fijar'  , 'nusantech'  , 'mitra infosarana'  , 'acis'  , 'ditama'  , 'beone'  , 'yusly'  , 'trimitrasis'  , 'it group'  , 'aim'  , 'codemi'  )
				 OR	a.talenta_name  in ( 'Sera Group mo88i'  )
				 OR	a.current_system_integrator  is not null
				 OR	a.platform_revenue  is not null) then 'P. Channel' /* end of  Channel Partnership */
				 when coalesce(a.payment_closing_date, a.sales_meeting_date, a.tele_assign_date, a.first_lead_status_updated, a.leads_created_time)  >= date('2023-01-01')
				 AND	lower(a.lead_source_sales_blended)  like '%inbound%channel%'
				 OR	(coalesce(a.payment_closing_date, a.sales_meeting_date, a.tele_assign_date, a.first_lead_status_updated, a.leads_created_time)  >= date('2023-01-01')
				 AND	lower(a.lead_source_blended)  like '%p.%channel%')
				 OR	(coalesce(a.payment_closing_date, a.sales_meeting_date, a.tele_assign_date, a.first_lead_status_updated, a.leads_created_time)  >= date('2023-01-01')
				 AND	a.lead_source_detail_blended  like '%-76690]%'
				 AND	lower(a.lead_medium_blended)  = 'website - chat wa') /*added by agnes, 10-oct'22*/
 OR	(coalesce(a.payment_closing_date, a.sales_meeting_date, a.tele_assign_date, a.first_lead_status_updated, a.leads_created_time)  >= date('2023-01-01')
				 AND	a.lead_source_detail_blended  like '%-52095]%'
				 AND	lower(a.lead_medium_blended)  = 'website - chat wa')
				 OR	(coalesce(a.payment_closing_date, a.sales_meeting_date, a.tele_assign_date, a.first_lead_status_updated, a.leads_created_time)  >= date('2023-01-01')
				 AND	a.lead_source_detail_blended  like '%-53459]%'
				 AND	lower(a.lead_medium_blended)  = 'website - chat wa') then 'P. Revenue' /* added by donner, 10-sep'22*/
				 when coalesce(a.payment_closing_date, a.sales_meeting_date, a.tele_assign_date, a.first_lead_status_updated, a.leads_created_time)  >= date('2023-01-01')
				 AND	((split_part(split_part(replace(a.lead_source_detail_blended, ' ', ''), '-',2), ']',1)  in ( '52095'  , '53459'  , '76690'  )
				 AND	coalesce(a.waba_utm_medium, b.lead_medium,'-')  is null)
				 OR	lower(a.lead_source_detail_blended)  in ( 'dgtraffic'  , 'docotel'  , 'elevenia'  , 'melvi'  , 'partner beonextalenta 160222'  , 'visiintech'  , 'nurosoft'  , 'adminku consulting'  , 'perkom'  , 'anduin'  , 'grace consultant'  , 'humanindo'  , 'fijar'  , 'nusantech'  , 'mitra infosarana'  , 'acis'  , 'ditama'  , 'beone'  , 'yusly'  , 'trimitrasis'  , 'it group'  , 'aim'  , 'codemi'  )
				 OR	a.talenta_name  in ( 'Sera Group mo88i'  )
				 OR	a.current_system_integrator  is not null
				 OR	(a.platform_revenue  is not null  and lower(a.lead_source_sales_blended) not like '%inbound%')) then 'P. Revenue' /* end of  Channel Partnership Revenue*/
				 when lower(a.lead_source_blended)  like '%referral%sales%'
				 AND	a.referral_code  is not null then 'Outbound'
				 when a.lead_source_blended  like 'outbound%'
				 OR	a.lead_source_blended  like 'SDR' then 'Outbound'
				 when a.lead_source_sales_blended  in ( 'Inbound - Referral'  , 'Referral - Program'  )
				 OR	a.referral_code  is not null
				 OR	lower(a.lead_source_blended)  like '%referral%' THEN 'Referral' /* end of  Referral */
				 when lower(coalesce(a.lead_source_blended, '-'))  in ( 'mail'  )
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'pos indonesia'  ) then 'Offline Mail'
				 when lower(a.lead_medium_blended)  like '%chat wa%'
				 AND	(lower(substr(a.lead_source_detail_blended,1, 5))  like '(%)'
				 OR	lower(substr(a.lead_source_detail_blended,1, 5))  like '%(01p)%'
				 OR	lower(substr(a.lead_source_detail_blended,1, 5))  like '%[01p]%') THEN 'WABA Blast'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  = 'waba'
				 AND	lower(a.lead_source_blended)  = 'crm' THEN 'WABA Blast' /* end of  WABA Blast */
				 when (date_format(a.leads_created_time,'%Y-%m')  < '2021-07'
				 AND	(lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%affiliate%website%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%referral%in%app%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%email%users%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%mekari.com%'))
				 /* OR	coalesce(f.urls, c.urls)  like '%mekari.com%' */ then 'Ecosystem'
				 when lower(coalesce(a.lead_source_detail_blended, '-'))  like '[S%'
				 OR	lower(a.lead_source_blended)  like '%ecosystem%'
				 OR	lower(coalesce(b.lead_medium, a.lead_medium_blended, '-'))  like '%ecosystem%'
				 OR	lower(coalesce(b.lead_medium, a.lead_medium_blended, '-'))  like '%sleekr%'
				 OR	lower(coalesce(b.lead_medium, a.lead_medium_blended, '-'))  like '%in-app%'
				 OR	lower(coalesce(b.lead_medium, a.lead_medium_blended, '-'))  like '%jurnal%'
				 OR	lower(coalesce(b.lead_medium, a.lead_medium_blended, '-'))  like '%talenta%'
				 OR	lower(coalesce(b.lead_medium, a.lead_medium_blended, '-'))  like '%qontak%'
				 OR	lower(coalesce(b.lead_medium, a.lead_medium_blended, '-'))  like '%mekari%'
				 OR	lower(coalesce(b.lead_medium, a.lead_medium_blended, '-'))  like '%klikpajak%'
				 OR	lower(coalesce(b.lead_medium, a.lead_medium_blended, '-'))  like '%esign%'  then 'Ecosystem' /*add by ag 20221118*/
				 when date_format(a.leads_created_time,'%Y-%m')  >= '2021-07'
				 AND	(a.lead_source_sales_blended  in ( 'Inbound - Marketing Digital Ecosystem'  , 'Inbound - Ecosystem'  , 'Cross Sell Jurnal - Inbound'  )
				 OR	lower(coalesce(a.form_name_blended, '-'))  like '%talenta starter%'
				 OR	lower(coalesce(a.form_name_blended, '-'))  like 'jurnal%post%inquiry%multi%product%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like 'jurnal%post%inquiry%multi%product%'
				 OR	(lower(a.lead_medium_blended)  like '%chat%'
				 AND	lower(a.lead_source_detail_blended)  like '[m%')) then 'Ecosystem' /* end of  Ecosystem, was Affiliate Web */
				 when lower(coalesce(a.lead_source_blended, '-'))  like '%email%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%email%'
				 OR	lower(coalesce(a.lead_source_sales_blended, '-'))  like '%email%' then 'Email' /* end of  Email */
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'performance max'  ) then 'Performance Max'
				 when /* 
                 lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  not like '%search%'
                 AND
                 */
/* remarked by donner, 27-dec'22, to prioritize Blog landing page   */ lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  not like '%non%'
				 AND	((date_format(a.created_time,'%Y-%m-%d')  <= '2021-12-31'
				 AND	((lower(coalesce(a.lead_source_blended, '-'))  like '%blog%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%blog%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%~ blog%')))
				 OR	(date_format(a.created_time,'%Y-%m-%d')  > '2021-12-31'
				 AND	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%~ blog%')
				 OR	coalesce(c.urls, '-')  like '%blog%')
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '[t4e%-blog%' then 'Blog' /* end of  Blog */
				 when lower(coalesce(a.lead_source_blended, '-'))  in ( 'google adwords'  , 'search ads'  )
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  , 'google - search'  , 'bing'  )
				 OR	lower(coalesce(a.lead_source_blended, '-') || coalesce(a.lead_medium_blended, '-') || coalesce(a.lead_source_detail_blended, '-') /*|| coalesce(e.campaign_name, '-')*/)  like '%bing%'
				 OR	(a.lead_medium_blended  is null
				 AND	(length(a.gclid)  > 5
				 OR	length(a.mkt_gclid)  > 5
				 OR	length(a.lead_channel)  >= 15)) then 'Search Ads' /* end of  Search Ads */
				 when ((length(a.gclid)  > 5
				 OR	length(a.mkt_gclid)  > 5
				 OR	length(a.lead_channel)  >= 15)
				 AND	lower(coalesce(a.lead_source_blended, '-'))  not in ( 'google adwords'  , 'search ads'  )
				 AND	(lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%display%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%display%'))
				 OR	lower(coalesce(a.lead_source_blended, '-'))  in ( 'ads platform'  , 'digital - trial direct sign up (p)'  , 'digital - sales inquiries (p)'  , 'mail'  , 'placement'  )
				 OR	lower(coalesce(a.lead_source_blended, '-'))  like '%leads gen%'
				 OR	lower(coalesce(a.lead_source_blended, '-'))  like '% ads%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'gdn'  , 'disocvery'  , 'uac'  , 'gmail'  , 'yt'  , 'fb'  , 'ig'  , 'li'  , 'tw'  , 'bing'  , 'programmatic'  , 'publishing media'  , 'social media influencer'  , '(i) social media influencer'  , 'e-commerce'  )
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%leads gen%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '% ads%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%change software - info hr%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%change software - fb group%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%change software - peter febian%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%change software - junarsyi%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%change software - eza hazami%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%change software - hrdbacot%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%change software - astic%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%leads gen%' then 'Non-Search PPC' /* end of  Non-Search PPC */
				 when lower(a.lead_source_sales_blended)  like '%inbound%event%'
				 OR	lower(coalesce(a.lead_source_blended, '-'))  like '%event%'
				 OR	lower(coalesce(a.lead_source_blended, '-'))  like '%offline%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%event%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%offline%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%~ 36779t%' then 'Event'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'social media - yt'  )
				 OR	lower(coalesce(a.lead_source_blended, '-'))  like '%social%media%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%(o)%' then 'Social Media'
				 when lower(coalesce(a.lead_source_blended, '-'))  like '%(e)%'
				 AND	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  not like '%whatsapp%'
				 AND	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  not like '%chat wa%'
				 AND	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  not like '%social media%' then 'Others'
				 else 'Organic'
			 end channel_group,
		 case
				 when lower(a.lead_source_sales_blended)  like '%event%'
				 OR	lower(a.lead_source_sales_blended)  like '%offline%' then replace(replace(trim(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(a.lead_source_detail_blended), ' ', ''), '_', ''), '1', ''), '2', ''), '3', ''), '4', ''), '5', ''), '6', ''), '7', ''), '8', ''), '9', ''), '0', '')), 'EVENT', ''), 'WEBINAR', '')
				 else '-'
			 end event_name_simplified,
		 case
				 when lower(a.product_name)  like '%sleekr%'
				 OR	concat(lower(a.lead_medium_blended), lower(a.lead_source_detail_blended))  like '%sleekr%' then 'Sleekr'
				 else 'Talenta'
			 end product_name,
		 a.no_of_employees as no_of_employees,
		 COALESCE(a.employee_size_category,'-') as employee_size_category,
		 COALESCE(a.telesales_inbound,'-') as telesales_inbound,
		 COALESCE(a.telesales_outbound,'-') as telesales_outbound,
		 COALESCE(a.stage,'-') as stage,
		 coalesce(a.gclid,  l.gclid_,  '-') gclid,
		 coalesce(a.mkt_gclid, l.gclid_,  '-') mkt_gclid,
		 COALESCE(a.cookie_id,'-') as cookie_id,
		 COALESCE(a.mkt_device_type,'-') as mkt_device_type,
		 coalesce(case
				 when l.short  is not null then l.device 
				 when n.short  is not null then n.device 
				 when lower(split_part(split_part(a.lead_source_detail_blended, '(',2), ')',1))  like '%w%' then 'Desktop'
				 when lower(split_part(split_part(a.lead_source_detail_blended, '(',2), ')',1))  like '%m%' then 'Mobile'
				 when lower(a.device_code)  like '%w%' then 'Desktop'
				 when lower(a.device_code)  like '%m%' then 'Mobile'
				 else '-'
			 end, a.mkt_device_type, '(undefined)') device_type,
		 case
				 when length(a.gclid) + length(a.mkt_gclid)  > 5
				 OR	length(a.lead_channel)  >= 15 then 'Y'
				 else 'N'
			 end gclid_flag,
		 COALESCE(a.city_state,'-') as city_state,
		 /*case
				 when a.city_state_lowercase  in ( 'jakarta'  , 'dkijakarta'  , 'jakartabarat'  , 'westjakarta'  , 'jakartapusat'  , 'centraljakarta'  , 'jakartaselatan'  , 'southjakarta'  , 'jakartatimur'  , 'eastjakarta'  , 'jakartautara'  , 'northjakarta'  , 'bogor'  , 'depok'  , 'tangerang'  , 'tangsel'  , 'tangerangselatan'  , 'bekasi'  , 'bekasibarat'  , 'bekasitimur'  , 'jabodetabek'  , 'bintaro'  , 'citeureupbogor'  , 'jakartautara-kelapagading'  , 'sentulcity'  , 'serpong'  , 'sunter'  ) then 'JKT'
				 when a.city_state_lowercase  in ( 'bali'  , 'denpasar'  , 'badung'  , 'bangli'  , 'buleleng'  , 'gianyar'  , 'jembrana'  , 'karangasem'  , 'klungkung'  , 'tabanan'  , 'denpasar-bali'  )
				 OR	a.city_state_lowercase  in ( 'bandung'  , 'bandungbarat'  , 'westbandung'  , 'subang'  , 'sukabumi'  , 'cianjur'  , 'purwakarta'  , 'tasik'  , 'tasikmalaya'  , 'garut'  , 'cirebon'  , 'indramayu'  )
				 OR	a.city_state_lowercase  in ( 'surabaya'  , 'sidoarjo'  , 'malang'  , 'gresik'  , 'kediri'  , 'pasuruan'  , 'madiun'  , 'tulungagung'  , 'probolinggo'  )
				 OR	a.city_state_lowercase  in ( 'medan'  , 'siantar'  , 'pematangsiantar'  , 'berastagi'  , 'kabanjahe'  , 'tebingtinggi'  , 'stabat'  , 'bukitlawang'  , 'padangsidempuan'  , 'mandailing'  , 'batubara'  ) 
				 OR	a.city_state_lowercase  in ( 'semarang/yogyakarta'  , 'yogyakarta'  , 'semarang'  , 'magelang'  , 'solo'  , 'surakarta'  , 'kudus'  , 'jogja'  , 'sleman'  ) then 'NX'
				 else 'INDO'
			 end as location_group,*/
		 lower(coalesce(trim(a.industry), '-undefined-')) industry,
		  case
				 when a.industry_group  in
					(
 					SELECT DISTINCT industry_group
					FROM  "prod-datalake-gsheet-marketing-analytics-uniqueid".industry 
					) then a.industry_group 
				 else k.industry_group
			 end  as industry_group,
		 date(a.sales_meeting_date) as sales_meeting_timestamp,
		 case
				 when date_format(current_date, '%Y-%m')  = date_format(a.sales_meeting_date, '%Y-%m') then 'This Month'
				 when date_format(current_date, '%Y-%m')  = date_format(date_add('month',1,a.sales_meeting_date), '%Y-%m') then 'Last Month'
				 when date_format(current_date, '%Y-%m')  = date_format(date_add('month',2,a.sales_meeting_date), '%Y-%m') then '2 Months Aging'
				 when date_format(current_date, '%Y-%m')  = date_format(date_add('month',3,a.sales_meeting_date), '%Y-%m') then '3 Months Aging'
				 when date_format(current_date, '%Y-%m') >= date_format(date_add('month',4,a.sales_meeting_date), '%Y-%m') then '>3 Months Aging'
				 else 'others'
			 end sql_cohort_by_today,
		 case
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(a.sales_meeting_date, '%Y-%m') then 'Same Month'
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(date_add('month',-1,a.sales_meeting_date), '%Y-%m') then 'Last Month'
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(date_add('month',-2,a.sales_meeting_date), '%Y-%m') then '2 Months Aging'
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(date_add('month',-3,a.sales_meeting_date), '%Y-%m') then '3 Months Aging'
				 when date_format(a.leads_created_time,'%Y-%m') <= date_format(date_add('month',-4,a.sales_meeting_date), '%Y-%m') then '>3 Months Aging'
				 else 'others'
			 end sql_cohort_by_raw,
		 case
				 when date_format(coalesce(a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(a.sales_meeting_date, '%Y-%m') then 'Same Month'
				 when date_format(coalesce(a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-1,a.sales_meeting_date), '%Y-%m') then 'Last Month'
				 when date_format(coalesce(a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-2,a.sales_meeting_date), '%Y-%m') then '2 Months Aging'
				 when date_format(coalesce(a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-3,a.sales_meeting_date), '%Y-%m') then '3 Months Aging'
				 when date_format(coalesce(a.sales_meeting_date, a.leads_created_time), '%Y-%m') <= date_format(date_add('month',-4,a.sales_meeting_date), '%Y-%m') then '>3 Months Aging'
				 else 'others'
			 end sql_cohort_by_sql,
		 date(coalesce(a.tele_assign_date, (
			case
				 when a.sales_meeting_date  > current_date then current_date
				 else a.sales_meeting_date
			 end))) tele_assign_date,
		 case
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(coalesce(a.tele_assign_date, a.sales_meeting_date), '%Y-%m') then 'Same Month'
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(date_add('month',-1,coalesce(a.tele_assign_date, a.sales_meeting_date)), '%Y-%m') then 'Last Month'
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(date_add('month',-2,coalesce(a.tele_assign_date, a.sales_meeting_date)), '%Y-%m') then '2 Months Aging'
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(date_add('month',-3,coalesce(a.tele_assign_date, a.sales_meeting_date)), '%Y-%m') then '3 Months Aging'
				 when date_format(a.leads_created_time,'%Y-%m') <= date_format(date_add('month',-4,coalesce(a.tele_assign_date, a.sales_meeting_date)), '%Y-%m') then '>3 Months Aging'
				 else 'others'
			 end sql_tele_assign_cohort_by_raw,
		 case
				 when date_format(coalesce(a.tele_assign_date, a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(coalesce(a.tele_assign_date, a.sales_meeting_date), '%Y-%m') then 'Same Month'
				 when date_format(coalesce(a.tele_assign_date, a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-1,coalesce(a.tele_assign_date, a.sales_meeting_date)), '%Y-%m') then 'Last Month'
				 when date_format(coalesce(a.tele_assign_date, a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-2,coalesce(a.tele_assign_date, a.sales_meeting_date)), '%Y-%m') then '2 Months Aging'
				 when date_format(coalesce(a.tele_assign_date, a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-3,coalesce(a.tele_assign_date, a.sales_meeting_date)), '%Y-%m') then '3 Months Aging'
				 when date_format(coalesce(a.tele_assign_date, a.sales_meeting_date, a.leads_created_time), '%Y-%m') <= date_format(date_add('month',-4,coalesce(a.tele_assign_date, a.sales_meeting_date)), '%Y-%m') then '>3 Months Aging'
				 else 'others'
			 end sql_tele_assign_cohort_by_sql,
		 date_format(a.sales_meeting_date, '%Y-%m-%d') sales_meeting_date,
		 date_format(a.sales_meeting_date, '%Y-%m') sales_meeting_month_year,
		 case
				 when day_of_week(a.first_lead_status_updated)  in ( 7  , 1  ) then 'Y'
				 else 'N'
			 end weekend_mql,
		 case
				 when day_of_week(a.sales_meeting_date)  in ( 7  , 1  ) then 'Y'
				 else 'N'
			 end weekend_sql,
		 COALESCE(a.meeting_status,'-') as meeting_status,
		 case
				 when lower(a.meeting_status)  = 'done' then a.stage
				 else coalesce(a.meeting_status, lower(a.lead_status))
			 end meeting_done_detail,
		 date_format(a.payment_closing_date, '%Y-%m-%d') payment_closing_date,
		 a.payment_closing_date as payment_closing_timestamp,
		 case
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(a.payment_closing_date, '%Y-%m') then 'Same Month'
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(date_add('month',-1,a.payment_closing_date), '%Y-%m') then 'Last Month'
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(date_add('month',-2,a.payment_closing_date), '%Y-%m') then '2 Months Aging'
				 when date_format(a.leads_created_time,'%Y-%m')  = date_format(date_add('month',-3,a.payment_closing_date), '%Y-%m') then '3 Months Aging'
				 when date_format(a.leads_created_time,'%Y-%m') <= date_format(date_add('month',-4,a.payment_closing_date), '%Y-%m') then '>3 Months Aging'
				 else 'others'
			 end won_cohort_by_raw,
		 case
				 when date_format(coalesce(a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(a.payment_closing_date, '%Y-%m') then 'Same Month'
				 when date_format(coalesce(a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-1,a.payment_closing_date), '%Y-%m') then 'Last Month'
				 when date_format(coalesce(a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-2,a.payment_closing_date), '%Y-%m') then '2 Months Aging'
				 when date_format(coalesce(a.sales_meeting_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-3,a.payment_closing_date), '%Y-%m') then '3 Months Aging'
				 when date_format(coalesce(a.sales_meeting_date, a.leads_created_time), '%Y-%m') <= date_format(date_add('month',-4,a.payment_closing_date), '%Y-%m') then '>3 Months Aging'
				 else 'others'
			 end won_cohort_by_sql,
		 case
				 when date_format(coalesce(a.tele_assign_date, a.leads_created_time), '%Y-%m')  = date_format(a.payment_closing_date, '%Y-%m') then 'Same Month'
				 when date_format(coalesce(a.tele_assign_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-1,a.payment_closing_date), '%Y-%m') then 'Last Month'
				 when date_format(coalesce(a.tele_assign_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-2,a.payment_closing_date), '%Y-%m') then '2 Months Aging'
				 when date_format(coalesce(a.tele_assign_date, a.leads_created_time), '%Y-%m')  = date_format(date_add('month',-3,a.payment_closing_date), '%Y-%m') then '3 Months Aging'
				 when date_format(coalesce(a.tele_assign_date, a.leads_created_time), '%Y-%m') <= date_format(date_add('month',-4,a.payment_closing_date), '%Y-%m') then '>3 Months Aging'
				 else 'others'
			 end won_cohort_by_sql_tele_assign,
		 case
				 when a.payment_closing_date  is not null then 'Y'
				 else 'N'
			 end payment_closing_date_flag,
		 date_format(a.payment_closing_date, '%Y-%m') payment_closing_month_year,
		 case
				 when lower(a.lead_source_sales_blended)  like '%web%demo%'
				 OR	lower(a.lead_source_sales_blended)  like '%soc%med%'
				 OR	lower(a.lead_source_sales_blended)  like '%event%' THEN a.sales_meeting_date
				 when lower(a.lead_source_sales_blended)  like '%web%inquir%'
				 OR	lower(a.lead_source_sales_blended)  like '%referral%' THEN a.first_lead_status_updated
				 when lower(a.lead_source_sales_blended)  like '%email%inquir%' THEN a.leads_created_time
				 else null
			 end opps_timestamp,
		 COALESCE(a.quotation_mrr,0) as quotation_mrr,
		 coalesce(a.mrr_after_disc, a.quotation_mrr, 0) * 1 new_mrr,
		 round((coalesce((a.mrr_after_disc), a.quotation_mrr, 0) * 1) / coalesce(a.no_of_employees, 1)) arpu_potential,
		 case
				 when round((coalesce((a.mrr_after_disc), a.quotation_mrr, 0) * 1) / coalesce(a.no_of_employees, 1))  < ((
					case
						 when a.company_segment  = 'Micro' then 24000
						 when a.company_segment  = 'Small' then 20500
						 when a.company_segment  = 'Mid' then 25000
						 when a.company_segment  = 'Large' then 14200
						 when a.company_segment  = 'Enterprise' then 7000
						 else 0
					 end) * 50 / 100) THEN 1 /* updated by donner, 12-Nov'21, to handle assumption discount up to 50%*/
				 else 0
			 end arpu_outlier,
			case
				 when round((coalesce((a.mrr_after_disc), a.quotation_mrr, 0) * 1) / coalesce(a.no_of_employees, 1))  < ((
					case
						 when a.company_segment  = 'Micro' then 24000
						 when a.company_segment  = 'Small' then 20500
						 when a.company_segment  = 'Mid' then 25000
						 when a.company_segment  = 'Large' then 14200
						 when a.company_segment  = 'Enterprise' then 7000
						 else 0
					 end) * 50 / 100) THEN 'Yes' /* updated by donner, 12-Nov'21, to handle assumption discount up to 50%*/
				 else 'No'
			 end is_arpu_outlier,
		 a.contract_length as contract_length,
		 a.contract_amount as contract_amount,
		 a.go_live_date as go_live_date,
		 a.full_start_date as contract_start_date,
		 COALESCE(substr(a.id,1, 15),'-') id,
		 coalesce(a.new_contract_end_date, a.full_end_date) contract_end_date,
		 COALESCE(a.product_package,'-') as  product_package,
		 upper(coalesce(a.referral_code, case
				 when lower(a.lead_source_detail_blended)  like 'talenta%'
				 AND	substr(a.lead_source_detail_blended, -1,1)  in ( '1'  , '2'  , '3'  , '4'  , '5'  , '6'  , '7'  , '8'  , '9'  , '0'  )
				 AND	length(a.lead_source_detail_blended)  <= 11 then a.lead_source_detail_blended
				 else '-'
			 end)) referral_code,
			/* -------------------------------- Stage Funnel -------------------------------- */
			case
				 when substr(a.stage, 1,1)  in ( 'S'  , 'T'  , 'U'  , 'V'  , 'W'  , 'X'  )
				 OR	a.lead_result  is not null /* added by donner, 21-aug'21 -- dropped mql */
				 OR	a.lead_status  = 'Closed' /* added by agnes, 29-sep'22 -- dropped mql */
				 OR	(/* added by donner, 5-jul'23 -- dropped raw */ lower(a.lead_status)  like '%junk%'
				 OR	lower(a.lead_status)  like '%paying%'
				 OR	lower(a.lead_status)  like '%duplicate%'
				 OR	lower(a.lead_status)  like '%wrong%') THEN 1
				 else 0
			 end drop_lost_flag,
		 1 raw_flag,
		 CASE
				 WHEN lower(coalesce(a.lead_status, '-'))  in ( 'closed'  , 'qualified lead'  , 'follow up'  /* 'not contacted'*/ , 'call back later'  , 'no answer'  )
				 OR	(a.lead_result  is not null
				 AND	a.lead_status  is null)
				 OR	coalesce(a.tele_assign_date, a.sales_meeting_date)  is not null THEN 1
				 ELSE 0
			 END mql_flag,
		 CASE
				 WHEN (lower(coalesce(a.lead_status, '-'))  in ( 'closed'  , 'qualified lead'  , 'follow up'  /* 'not contacted'*/ , 'call back later'  , 'no answer'  )
				 OR	(a.lead_result  is not null
				 AND	a.lead_status  is null)
				 OR	coalesce(a.tele_assign_date, a.sales_meeting_date)  is not null)
				 AND	date_format(coalesce(a.first_lead_status_updated, a.tele_assign_date, a.sales_meeting_date), '%Y-%m-01')  > date_format(a.leads_created_time,'%Y-%m-01') THEN 0
				 ELSE 1
			 END mql_same_month_flag,
			/*to compare MQL with CRM Business Dashboard */
			CASE
				 WHEN lower(coalesce(a.lead_status, '-'))  in ( 'qualified lead'  , 'follow up'  , 'call back later'  , 'no answer'  )
				 OR	coalesce(a.tele_assign_date, a.sales_meeting_date)  is not null THEN 1
				 ELSE 0
			 END mql_qualified_open_flag,
		 CASE
				 WHEN lower(coalesce(a.lead_status, '-'))  in ( 'qualified lead'  )
				 OR	coalesce(a.tele_assign_date, a.sales_meeting_date)  is not null THEN 1
				 ELSE 0
			 END mql_qualified_flag,
		 CASE
				 WHEN coalesce(a.tele_assign_date, a.sales_meeting_date)  is not null
				 OR	lower(a.meeting_status)  = 'done' THEN 1
				 ELSE 0
			 END sql_flag,
		 CASE
				 WHEN coalesce(a.tele_assign_date, a.sales_meeting_date)  is not null
				 OR	lower(a.meeting_status)  = 'done' THEN 1
				 ELSE 0
			 END sql_tele_assign_flag,
		 CASE
				 WHEN lower(a.meeting_status)  = 'done' THEN 1
				 ELSE 0
			 END meeting_flag,
		 CASE
				 WHEN /* (lower(coalesce(a.lead_status, '-'))  in ( 'closed'  , 'qualified lead'  , 'follow up' , 'not contacted'*/
/* , 'call back later'  , 'no answer'  )*/
/* OR	a.sales_meeting_date  is not null)*/
/* AND	a.sales_meeting_date  is not null*/
/* AND	*/
/* remarked by donner 9-aug'21 */ a.payment_closing_date  is not null THEN 1
				 ELSE 0
			 END won_flag,
		 CASE
				 WHEN date_format((
					CASE
						 WHEN a.first_lead_status_updated  IS NULL THEN (
							CASE
								 WHEN a.sales_meeting_date  IS NOT NULL THEN a.sales_meeting_date
								 ELSE a.leads_created_time
							 END)
						 ELSE a.first_lead_status_updated
					 END), '%Y-%m')  = date_format(a.leads_created_time,'%Y-%m') THEN 1
				 ELSE 0
			 END first_lead_status_updated_same_month_flag,
		 CASE
				 WHEN date_format((
					CASE
						 WHEN a.first_lead_status_updated  IS NULL THEN (
							CASE
								 WHEN a.sales_meeting_date  IS NOT NULL THEN a.sales_meeting_date
								 ELSE a.leads_created_time
							 END)
						 ELSE a.first_lead_status_updated
					 END), '%Y-%m')  = date_format(a.leads_created_time,'%Y-%m') THEN 'Yes'
				 ELSE 'No'
			 END is_first_lead_status_updated_same_month,
		 CASE
				 WHEN date_format(a.sales_meeting_date, '%Y-%m')  = date_format(a.leads_created_time,'%Y-%m') THEN 1
				 ELSE 0
			 END sql_same_month_flag,
		 CASE
				 WHEN date_format(a.sales_meeting_date, '%Y-%m')  > date_format(a.leads_created_time,'%Y-%m') THEN 1
				 ELSE 0
			 END sql_non_same_month_flag,
		 CASE
				 WHEN date_format(coalesce(a.tele_assign_date, a.sales_meeting_date), '%Y-%m')  = date_format(a.leads_created_time,'%Y-%m') THEN 'Yes'
				 ELSE 'No'
			 END is_sql_same_month,
		 CASE
				 WHEN date_format(coalesce(a.tele_assign_date, a.sales_meeting_date), '%Y-%m')  = date_format(a.leads_created_time,'%Y-%m') THEN 1
				 ELSE 0
			 END sql_tele_assign_same_month_flag,
		 CASE
				 WHEN date_format(coalesce(a.tele_assign_date, a.sales_meeting_date), '%Y-%m')  > date_format(a.leads_created_time,'%Y-%m') THEN 1
				 ELSE 0
			 END sql_tele_assign_non_same_month_flag,
		 CASE
				 WHEN date_format(a.sales_meeting_date, '%Y-%m')  = date_format(a.leads_created_time,'%Y-%m')
				 AND	lower(a.meeting_status)  = 'done' THEN 1
				 ELSE 0
			 END meeting_same_month_flag,
		 CASE
				 WHEN date_format(a.payment_closing_date, '%Y-%m')  = date_format(a.leads_created_time,'%Y-%m') THEN 1
				 ELSE 0
			 END won_same_month_flag,
		 CASE
				 WHEN date_format(a.payment_closing_date, '%Y-%m')  = date_format(a.leads_created_time,'%Y-%m') THEN 'Yes'
				 ELSE 'No'
			 END is_won_same_month,
			/* -------------------------------- End of Stage Funnel -------------------------------- */
			case
				 when /* replace(f.urls, 'https://www.talenta.co', '')  in
					(
 					SELECT DISTINCT "URL"
					FROM  "Company Segment by URL" 
					WHERE	 "Segment"  = 'Enterprise'
					 AND	"Tribe"  = 'Talenta'
					)
				 AND */	a.company_segment  not in ( 'Large'  , 'Enterprise'  )
				 AND	coalesce(a.tele_assign_date, a.sales_meeting_date)  is null
				 AND	lower(a.meeting_status)  <> 'done'
				 AND	a.payment_closing_date  is null then 'Enterprise'
				 else coalesce(a.company_segment,'-')
			 end company_segment,
		 case
				 when /* replace(f.urls, 'https://www.talenta.co', '')  in
					(
 					SELECT DISTINCT "URL"
					FROM  "Company Segment by URL" 
					WHERE	 "Segment"  in ( 'Enterprise'  )
					 AND	"Tribe"  = 'Talenta'
					)
				 AND	*/ a.company_segment  not in ( 'Large'  , 'Enterprise'  )
				 AND	coalesce(a.tele_assign_date, a.sales_meeting_date)  is null
				 AND	lower(a.meeting_status)  <> 'done'
				 AND	a.payment_closing_date  is null then 'Enterprise'
				 when lower(a.employee_size_category)  like '%enterprise%' then 'Enterprise'
				 when lower(a.employee_size_category)  like '%medium%'
				 OR	lower(a.employee_size_category)  like '%large%'
				 OR	lower(a.employee_size_category)  like '%big %' then 'Medium-Large'
				 when lower(a.employee_size_category)  like '%micro%'
				 OR	lower(a.employee_size_category)  like '%small%' then 'Micro-Small'
				 else '(undefined)'
			 end company_segment_group,
		 case
				 when lower(a.lead_medium_blended)  like '%hosted%event%' then 'hosted event'
				 when lower(a.lead_medium_blended)  like '%tap%in%' then 'tap in'
				 when lower(a.lead_medium_blended)  like '%expo%' then 'exhibition'
				 when lower(a.lead_medium_blended)  like '%live%demo%' then 'live demo'
				 when lower(a.lead_source_blended)  like '%hosted%event%' then 'hosted event'
				 when (a.lead_medium_blended  is null
				 AND	lower(a.lead_source_blended)  like '%tap%in%') then 'tap in'
				 when a.lead_medium_blended  is null then '(empty)'
				 else COALESCE(lower(a.lead_medium_blended),'-')
			 end lead_medium_new,
		 case
				 when lower(a.lead_source_detail_blended)  like '%manual%update%' then 'Recycle'
				 else 'New'
			 end event_medium,
		 case
				 when lower(a.lead_source_detail_blended)  like '%manual%update%' then (concat(case
						 when lower(a.lead_medium_blended)  like '%hosted%event%' then 'hosted event'
						 when lower(a.lead_medium_blended)  like '%tap%in%' then 'tap in'
						 when lower(a.lead_medium_blended)  like '%expo%' then 'exhibition'
						 when lower(a.lead_medium_blended)  like '%live%demo%' then 'live demo'
						 when lower(a.lead_source_blended)  like '%hosted%event%' then 'hosted event'
						 when (a.lead_medium_blended  is null
						 AND	lower(a.lead_source_blended)  like '%tap%in%') then 'tap in'
						 when a.lead_medium_blended  is null then '(empty)'
						 else lower(a.lead_medium_blended)
					 end, ' - Recycle'))
				 else (
					case
						 when lower(a.lead_medium_blended)  like '%hosted%event%' then 'hosted event'
						 when lower(a.lead_medium_blended)  like '%tap%in%' then 'tap in'
						 when lower(a.lead_medium_blended)  like '%expo%' then 'exhibition'
						 when lower(a.lead_medium_blended)  like '%live%demo%' then 'live demo'
						 when lower(a.lead_source_blended)  like '%hosted%event%' then 'hosted event'
						 when (a.lead_medium_blended  is null
						 AND	lower(a.lead_source_blended)  like '%tap%in%') THEN 'tap in'
						 when a.lead_medium_blended  is null then '(empty)'
						 else lower(a.lead_medium_blended)
					 end)
			 end lead_medium_event_medium,
			 date_diff('day', a.leads_created_time, current_date) + 1 -
        date_diff('week', a.leads_created_time, DATE_ADD('day', 1, current_date)) -
        date_diff('week', a.leads_created_time, current_date) as raw_duration_day,
		date_diff('day', case
				 when a.first_lead_status_updated  is null then (
					case
						 when a.sales_meeting_date  is not null
						 AND	a.sales_meeting_date  >= current_date then a.leads_created_time
						 when a.sales_meeting_date  is not null
						 AND	a.sales_meeting_date  < current_date then a.sales_meeting_date
						 else a.leads_created_time
					 end)
				 else a.first_lead_status_updated
			 end, current_date) + 1 -
        date_diff('week', case
				 when a.first_lead_status_updated  is null then (
					case
						 when a.sales_meeting_date  is not null
						 AND	a.sales_meeting_date  >= current_date then a.leads_created_time
						 when a.sales_meeting_date  is not null
						 AND	a.sales_meeting_date  < current_date then a.sales_meeting_date
						 else a.leads_created_time
					 end)
				 else a.first_lead_status_updated
			 end, DATE_ADD('day', 1, current_date)) -
        date_diff('week', case
				 when a.first_lead_status_updated  is null then (
					case
						 when a.sales_meeting_date  is not null
						 AND	a.sales_meeting_date  >= current_date then a.leads_created_time
						 when a.sales_meeting_date  is not null
						 AND	a.sales_meeting_date  < current_date then a.sales_meeting_date
						 else a.leads_created_time
					 end)
				 else a.first_lead_status_updated
			 end, current_date) mql_duration_day,
			 date_diff('day', a.last_lead_status_updated, current_date) + 1 -
        date_diff('week', a.last_lead_status_updated, DATE_ADD('day', 1, current_date)) -
        date_diff('week', a.last_lead_status_updated, current_date) mql_duration_by_last_update_day,
		 case
				 when lower(a.lead_status)  like '%paying client%' then 'Yes'
				 else 'No'
			 end is_paying_client,
		 'No' is_domain_registered,
		 COALESCE(a.is_recycle,'-') as is_recycle,
		 case
				 when coalesce(a.lead_status, '-')  in ( 'Test Data'  )
				 OR	concat(lower(coalesce(a.pic_name_hrd, ' ')), ' ', lower(coalesce(a.email, ' ')), ' ', lower(coalesce(a.pic_email_hrd, ' ')), ' ', lower(coalesce(a.talenta_name, ' ')), ' ', lower(coalesce(a.lead_source_blended, ' ')), ' ', lower(coalesce(a.lead_medium_blended, ' ')), ' ', lower(coalesce(a.lead_source_detail_blended, ' ')))  like 'test %'
				 OR	concat(lower(coalesce(a.pic_name_hrd, ' ')), ' ', lower(coalesce(a.email, ' ')), ' ', lower(coalesce(a.pic_email_hrd, ' ')), ' ', lower(coalesce(a.talenta_name, ' ')), ' ', lower(coalesce(a.lead_source_blended, ' ')), ' ', lower(coalesce(a.lead_medium_blended, ' ')), ' ', lower(coalesce(a.lead_source_detail_blended, ' ')))  like '% test %'
				 OR	concat(lower(coalesce(a.pic_name_hrd, ' ')), ' ', lower(coalesce(a.email, ' ')), ' ', lower(coalesce(a.pic_email_hrd, ' ')), ' ', lower(coalesce(a.talenta_name, ' ')), ' ', lower(coalesce(a.lead_source_blended, ' ')), ' ', lower(coalesce(a.lead_medium_blended, ' ')), ' ', lower(coalesce(a.lead_source_detail_blended, ' ')))  like '% test'
				 OR	concat(lower(coalesce(a.pic_name_hrd, ' ')), ' ', lower(coalesce(a.email, ' ')), ' ', lower(coalesce(a.pic_email_hrd, ' ')), ' ', lower(coalesce(a.talenta_name, ' ')), ' ', lower(coalesce(a.lead_source_blended, ' ')), ' ', lower(coalesce(a.lead_medium_blended, ' ')), ' ', lower(coalesce(a.lead_source_detail_blended, ' ')))  like 'testing %'
				 OR	concat(lower(coalesce(a.pic_name_hrd, ' ')), ' ', lower(coalesce(a.email, ' ')), ' ', lower(coalesce(a.pic_email_hrd, ' ')), ' ', lower(coalesce(a.talenta_name, ' ')), ' ', lower(coalesce(a.lead_source_blended, ' ')), ' ', lower(coalesce(a.lead_medium_blended, ' ')), ' ', lower(coalesce(a.lead_source_detail_blended, ' ')))  like '% testing %'
				 OR	concat(lower(coalesce(a.pic_name_hrd, ' ')), ' ', lower(coalesce(a.email, ' ')), ' ', lower(coalesce(a.pic_email_hrd, ' ')), ' ', lower(coalesce(a.talenta_name, ' ')), ' ', lower(coalesce(a.lead_source_blended, ' ')), ' ', lower(coalesce(a.lead_medium_blended, ' ')), ' ', lower(coalesce(a.lead_source_detail_blended, ' ')))  like '% testing'
				 OR	concat(lower(coalesce(a.pic_name_hrd, ' ')), ' ', lower(coalesce(a.email, ' ')), ' ', lower(coalesce(a.pic_email_hrd, ' ')), ' ', lower(coalesce(a.talenta_name, ' ')), ' ', lower(coalesce(a.lead_source_blended, ' ')), ' ', lower(coalesce(a.lead_medium_blended, ' ')), ' ', lower(coalesce(a.lead_source_detail_blended, ' ')))  like 'dummy %'
				 OR	concat(lower(coalesce(a.pic_name_hrd, ' ')), ' ', lower(coalesce(a.email, ' ')), ' ', lower(coalesce(a.pic_email_hrd, ' ')), ' ', lower(coalesce(a.talenta_name, ' ')), ' ', lower(coalesce(a.lead_source_blended, ' ')), ' ', lower(coalesce(a.lead_medium_blended, ' ')), ' ', lower(coalesce(a.lead_source_detail_blended, ' ')))  like '% dummy %'
				 OR	concat(lower(coalesce(a.pic_name_hrd, ' ')), ' ', lower(coalesce(a.email, ' ')), ' ', lower(coalesce(a.pic_email_hrd, ' ')), ' ', lower(coalesce(a.talenta_name, ' ')), ' ', lower(coalesce(a.lead_source_blended, ' ')), ' ', lower(coalesce(a.lead_medium_blended, ' ')), ' ', lower(coalesce(a.lead_source_detail_blended, ' ')))  like '% dummy' then 'Yes'
				 else 'No'
			 end is_test_data,
		 case
				 when lower(coalesce(a.lead_medium_blended, '-'))  like '%chat wa%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '[%-%]%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '[%.%]%' then 'Yes'
				 else 'No'
			 end is_waba,
			case
				 when l.short  is not null then l.first_journey_page
				 when n.short  is not null then n.first_journey_page
				 when l.short  is null then a.landing_page
				 else null
			 end landing_page_code, 
		 COALESCE(a.goal_previous_step_1,'-') as goal_previous_step_1_code,
		 coalesce(a.goal_previous_step_2,'-') as goal_previous_step_2_code,
		 coalesce(a.completion_location,'-')  as completion_location_code,
		 coalesce(a.telesales_notes,'-') as telesales_notes,
		 coalesce(a.sales_notes,'-') as sales_notes,
		 a.mql_drop_date as mql_drop_date,
		 coalesce(l."button_label_&_button_id", n."button_label_&_button_id") as "button_label_&_button_id",
		 coalesce(l.journey, n.journey)  journey_page_id,
		 coalesce( l.gclid_, n.gclid_, a.gclid, a.mkt_gclid,'-') gclid_blended,
		 case
				 when l.short  is not null then l.msclkid_
				 when n.short  is not null then n.msclkid_
				 when l.short  is null then a.msclkid
				 else null
			 end  as msclkid,
		 COALESCE(a.short,'-') as short,
		 /*a.city_state_lowercase as city_state_lowercase, */
		 /* c.urls "url test", */
		 COALESCE(a.talenta_owner,'-') as talenta_owner,
		 case when lower(coalesce(a.lead_source_detail_blended, '-'))  like 'aitindo%' then 'Yes'
				 else 'No'
			 end is_aitindo_campaign, 
		 case
				 when l.short  is not null then l.first_visited_timestamp
				 when n.short  is not null then n.first_visited_timestamp
				 when l.short  is null then a.first_visited_timestamp
				 else null
			 end as first_visited_timestamp,
		0 as traffic_to_raw_hour,
		 case
				 when lower(coalesce(a.lead_source_detail_blended, '-'))  like '%[m%' /* or lower(coalesce("Lead Source Detail", '-'))  like '%~%m%' notes: ~ m bisa jadi bukan M kode page, tapi kode device */
 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%mekari.com%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%m01%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'mekari (web)'  , 'referral - affiliate website (mekari)'  , '(i) referral - affiliate website (mekari)'  ) then 'Mekari.com'
				 when lower(coalesce(a.lead_source_detail_blended, '-'))  like '[s%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%sleekr%' then 'Sleekr.com'
				 when lower(coalesce(a.lead_source_detail_blended, '-'))  like '%post inquiry multi product%'
				 OR	lower(coalesce(a.form_name, '-'))  like '%post inquiry multi product%' then 'PIMP'
				 when coalesce(a.form_name, '-')  in ( 'Talenta Starter from Paying Users Jurnal'  ) then 'Talenta Starter with Jurnal'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%mekari univ%' then 'Mekari University'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like 'talenta (%)'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like 'jurnal (%)'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like 'klikpajak (%)'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like 'qontak (%)'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%(jurnal)%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%[t%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%[j%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%[k%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%[q%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  in ( 'tokyo jurnal'  )
				 OR	coalesce(a.form_name, '-')  in ( 'Talenta Starter from Drop Leads Talenta'  , 'Jurnal Add On'  ) then 'Cross Sell'
				 else '-'
			 end ecosystem_source,
		 case
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'google search'  , 'google ads - search'  ) then 'Search Ads'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'gdn'  , 'discovery'  , 'uac'  , 'fb'  , 'tw'  , 'tt'  , 'ig'  , 'li'  , 'yt'  ) then 'Non-search PPC'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'blog'  )
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%~ blog%' then 'Blog'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%email%' then 'Email'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%event%' then 'Event'
				 when lower(coalesce(a.lead_source_detail_blended, '-'))  in ( 'mekari.com'  , 'waba mekari.com'  , 'waba-mekari.com'  , 'website - leads form / mekari.com'  ) then '(undefined)'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'product page'  , 'incoming call'  )
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%in-app%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%(web)%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%affiliate website%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%~%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%m1a%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%m01%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%s1a%' then 'Organic'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%(o)%' then 'Social Media'
				 else '(undefined)'
			 end ecosystem_leading_channel,
		 case
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  not like '%(o)%'
				 AND	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  not in ( 'social media - yt'  )
				 AND	(lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%youtube%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%yt%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '% yt%') then 'G. YouTube'
				 when lower(coalesce(a.lead_source_detail_blended, '-'))  like '%discover%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%gmail%' then 'G. Discovery'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%display%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%gdn%' then 'G. Display'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'fb'  , 'ig'  )
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%fb%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%facebook%'
				 OR	lower(coalesce(a.lead_source_detail_blended, '-'))  like '%fb%' then 'FB/IG'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%influencer%' then 'Influencer'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%tw%' then 'Twitter'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '% li'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like 'li %'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  = 'li'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%linkedin%' then 'LinkedIn'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  like '%pos%indo%'
				 OR	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  = 'mail' then 'Pos Indo'
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  = 'tt' then 'TikTok'
				 else '-'
			 end non_search_ppc_source,
		 date_format(a.leads_created_time, '%W') day_of_raw_leads,
		 date_format(coalesce(a.first_lead_status_updated, a.leads_created_time), '%W') day_of_leads_followed_up,
		 date_format(a.sales_meeting_date, '%W') day_of_actual_meeting,
		 date_format(a.tele_assign_date, '%W') day_of_meeting_set_up,
		 date_format(a.payment_closing_date, '%W') day_of_payment,
		 date_diff('day', a.leads_created_time, a.payment_closing_date) + 1 -
			date_diff('week', a.leads_created_time, DATE_ADD('day', 1, a.payment_closing_date)) -
			date_diff('week', a.leads_created_time, a.payment_closing_date) raw_to_won_wd,
		 case
				 when lower(coalesce(a.lead_source_blended, '-'))  not in ( 'google adwords'  , 'search ads'  )
				 AND	lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  , 'google - search'  , 'bing'  )
				 AND	lower(coalesce(a.lead_source_blended, '-') || coalesce(a.lead_medium_blended, '-') || coalesce(a.lead_source_detail_blended, '-') /*|| coalesce(e.campaign_name, '-')*/)  not like '%bing%'
				 AND	length(coalesce(a.gclid, '-'))  <= 5
				 AND	length(coalesce(a.mkt_gclid, '-'))  <= 5
				 AND	length(coalesce(a.lead_channel, '-'))  < 15 then '-'
				 when lower(coalesce(a.lead_source_detail_blended, '-'))  like '%manual update%'
				 OR	(lower(coalesce(a.lead_source_detail_blended, '-'))  not like '%|%'
				 AND	lower(coalesce(a.lead_source_detail_blended, '-'))  not like '%]%') then '-'
				 when lower(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'))  like '%brand%' then 'brand'
				 when lower(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'))  like '%payroll%' then 'payroll'
				 when lower(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'))  like '%performance%' then 'performance'
				 when lower(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'))  like '%attendance%' then 'attendance'
				 when lower(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'))  like '%hris%' then 'hris'
				 when lower(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'))  like '%hr%' then 'hr'
				 when lower(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'))  like '%competitor%' then 'competitors'
				 when lower(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'))  like '%gaji%'
				 OR lower(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'))  like '%salary%' then 'gaji'
				 when lower(replace(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'),' ',''))  like '%recruitment%' 
				   OR lower(replace(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'),' ',''))  like '%data%' 
				   OR lower(replace(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'),' ',''))  like '%helpdesk%'
				   OR lower(replace(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'),' ',''))  like '%analytics%'
				   OR lower(replace(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'),' ',''))  like '%form%'
				   OR lower(replace(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'),' ',''))  like '%expense%'
				   OR lower(replace(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'),' ',''))  like '%ess%'
				   OR lower(replace(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'),' ',''))  like '%software%'
				   OR lower(replace(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'),' ',''))  like '%hardware%' then 'recruitment, database, helpdesk, analytics, form, expense, ess, software, hardware'
				 when lower(coalesce(e.campaign_name, j.campaign_name, d.campaign_name__t_, a.lead_source_detail_blended, '-'))  like '%dsa%' then 'dsa'
				 else 'Others' end ads_feature,
			/*case
				 when l.short  is not null then business_days(case
						 when date_format(l.first_visited_timestamp, '%H%m')  > 1500 then add_date(l.first_visited_timestamp, 1)
						 else l.first_visited_timestamp
					 end, a.leads_created_time) + 1
				 when n.short  is not null then business_days(case
						 when date_format(n.first_visited_timestamp, '%H%m')  > 1500 then add_date(n.first_visited_timestamp, 1)
						 else n.first_visited_timestamp
					 end, a.leads_created_time) + 1
				 else business_days(a.first_visited_timestamp, a.leads_created_time) + 1
			 end */  date_diff('day', coalesce(a.first_visited_timestamp,a.leads_created_time), a.leads_created_time) + 1 -
			date_diff('week', coalesce(a.first_visited_timestamp,a.leads_created_time), DATE_ADD('day', 1, a.leads_created_time)) -
			date_diff('week', coalesce(a.first_visited_timestamp,a.leads_created_time), a.leads_created_time) as traffic_to_raw_day,
		 a.no_deal_status no_deal_status,
			case
				 when lower(coalesce(a.waba_utm_medium, b.lead_medium,  a.lead_medium_blended, '-'))  in ( 'incoming call'  , 'webcall'  ) then 'Yes'
				 else 'No'
			 end is_call,
		 concat('zcrm_', a.id) zcrm_id
from
(
SELECT case WHEN (lower(lead_source_sales)  not like '%trial%'
		OR	lower(lead_source_sales)  not like '%web demo%')
		AND	lower(lead_source_sales)  not like '%inquir%'
		AND	LOWER(lead_source_detail)  LIKE '%manual%update%' THEN DATE(date_parse(substr(lead_source_detail,1, 6), '%y%m%d'))
	ELSE created_time END leads_created_time,
	CASE WHEN created_time  IS NOT NULL THEN 'No'
					 ELSE 'No'
				 END is_recycle,
			 created_time,
			 registered_time,
			 modified_time,
			 company_id,
			 demo_company_id,
			 deal_name as talenta_name,
			 pic_name as pic_name_hrd,
			 pic_phone as pic_phone_hrd,
			 is_subsidiary_of_holding_company as is_part_of_holding_group,
			 holding_group_name,
			 current_system_integrator,
			 platform_revenue,
			 email,
			 pic_email as pic_email_hrd,
			 lead_origin,
			 lead_type,
			 lead_sub_type,
			 lead_channel,
			 form_name,
			 complementary_product,
			 first_lead_status_updated, 
				case
					 when lower(latest_lead_source_detail)  like '%wa_unreachable%' then (
						case
							 when latest_nurturing_date  > last_lead_status_updated then latest_nurturing_date
							 else coalesce(last_lead_status_updated, latest_nurturing_date)
						 end)
					 else last_lead_status_updated
				 end as last_lead_status_updated,
			 lead_status,
			 lead_result,
			 product_name,
			 no_of_employees,
			 employee_size_category,
			 employee_size_grouping,
			 case when no_of_employees  > 700 then 'Enterprise'
					 when no_of_employees  between 301  AND  700 then 'Large'
					 when no_of_employees  between 101  AND  300 then 'Mid'
					 when no_of_employees  between 51  AND  100 then 'Small'
					 when no_of_employees  <= 50 then 'Micro'
					 when lower(employee_size_category)  like '%enterprise%' then 'Enterprise'
					 when lower(employee_size_category)  like '%large%' then 'Large'
					 when lower(employee_size_category)  like '%medium%'
					 OR	lower(employee_size_category)  like '%big %' then 'Mid'
					 when lower(employee_size_category)  like '%small%' then 'Small'
					 when lower(employee_size_category)  like '%micro%' then 'Micro'
					 else '(undefined)'
				 end as company_segment,
			 telesales_inbound,
			 telesales_outbound,
			 stage,
			 gclid,
			 case
					 when mkt_gclid  like '%|%' then split_part(replace(mkt_gclid, 'gclid=', ''), '|',1)
					 else replace(mkt_gclid, 'gclid=', '')
				 end mkt_gclid,
			case
					 when length(split_part(replace(mkt_gclid, ' msclkid=', ''), '|',2))  > 1 then split_part(replace(mkt_gclid, ' msclkid=', ''), '|',2)
					 else '-'
				 end msclkid,
			 cookie_id,
			 city_state,
			  case when replace(lower(city_state), ' ', '')  like '%,jakar%'
					 OR	replace(lower(city_state), ' ', '')  like '%,%bekasi%'
					 OR	replace(lower(city_state), ' ', '')  like '%,%tangeran%' then split_part(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(lower(city_state), ' ', ''), 'kabupaten', ''), 'kota', ''), 'kab.', ''), 'tangeranselatan', 'tangerangselatan'), 'jakarata', 'jakarta'), 'jakaratimur', 'jakartatimur'), 'jakarat', 'jakarta'), 'jaksel', 'jakartaselatan'), 'cikarang', 'bekasi'), 'tanggerang', 'tangerang'), 'regency', ''), 'sby', 'surabaya'), 'gersik', 'gresik'), 'diyogyakarta', 'yogyakarta'), 'diy', 'yogyakarta'), 'ypgyakarta', 'yogyakarta'), 'daerahistimewa', ''), 'distro', ''), 'pt.masarijaya', ''), 'kabsleman', 'sleman'), ',',2)
					 when replace(lower(city_state), ' ', '')  like '%,%' then split_part(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(lower(city_state), ' ', ''), 'kabupaten', ''), 'kota', ''), 'kab.', ''), 'tangeranselatan', 'tangerangselatan'), 'jakarata', 'jakarta'), 'jakaratimur', 'jakartatimur'), 'jakarat', 'jakarta'), 'jaksel', 'jakartaselatan'), 'cikarang', 'bekasi'), 'tanggerang', 'tangerang'), 'regency', ''), 'sby', 'surabaya'), 'gersik', 'gresik'), 'diyogyakarta', 'yogyakarta'), 'diy', 'yogyakarta'), 'ypgyakarta', 'yogyakarta'), 'daerahistimewa', ''), 'distro', ''), 'pt.masarijaya', ''), 'kabsleman', 'sleman'), ',',1)
					 else replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(lower(city_state), ' ', ''), 'kabupaten', ''), 'kota', ''), 'kab.', ''), 'tangeranselatan', 'tangerangselatan'), 'jakarata', 'jakarta'), 'jakaratimur', 'jakartatimur'), 'jakarat', 'jakarta'), 'jaksel', 'jakartaselatan'), 'cikarang', 'bekasi'), 'tanggerang', 'tangerang'), 'regency', ''), 'sby', 'surabaya'), 'gersik', 'gresik'), 'diyogyakarta', 'yogyakarta'), 'diy', 'yogyakarta'), 'ypgyakarta', 'yogyakarta'), 'daerahistimewa', ''), 'distro', ''), 'pt.masarijaya', ''), 'kabsleman', 'sleman')
				 end city_state_lowercase,
			 industry,
			 industry_group,
			  case when (latest_form_name  in ( 'Resurrected Leads'  , 'Email Nurturing Inquiry Form'  ) /* for resurrected leads */ /* for resurrected leads */
					 OR	((lower(latest_lead_source_detail)  like '%51253]%' /* for resurrected leads from change software campaign */ OR	lower(latest_lead_source_detail)  like '(01e)%')
					 AND	created_time  <= date_add('day', -33, latest_nurturing_date)) /* for resurrected leads from change software campaign */ OR	latest_lead_source_sales  in ( 'Inbound - Marketing Digital Email Inquiries'  , 'Inbound - Email Inquiries'  ) /* for resurrected leads from email */ /* for resurrected leads from email */
					 OR	(latest_lead_medium  = 'website - chat wa'
					 AND	created_time  <= date_add('day', -33, latest_nurturing_date)) /* for resurrected leads from WABA with created date min. 33 days before Latest Nurturing Date */
)
					 and date_format(case
							 when (lower(lead_source_sales)  not like '%trial%'
							 OR	lower(lead_source_sales)  not like '%web demo%')
							 AND	lower(lead_source_sales)  not like '%inquir%'
							 AND	lower(lead_source_detail)  LIKE '%manual%update%' then date(date_parse(substr(lead_source_detail,1, 6), '%y%m%d'))
							 else created_time
						 end,'%Y%m')  != date_format(latest_nurturing_date,'%Y%m') then null
					 else coalesce(sales_meeting_date, payment_closing_date)
				 end/* to prevent double count SQL */ sales_meeting_date,
			  case when (latest_form_name  in ( 'Resurrected Leads'  , 'Email Nurturing Inquiry Form'  ) /* for resurrected leads */ /* for resurrected leads */
					 OR	((lower(latest_lead_source_detail)  like '%51253]%' /* for resurrected leads from change software campaign */ OR	lower(latest_lead_source_detail)  like '(01e)%')
					 AND	created_time  <= date_add('day', -33, latest_nurturing_date)) /* for resurrected leads from change software campaign */ OR	latest_lead_source_sales  in ( 'Inbound - Marketing Digital Email Inquiries'  , 'Inbound - Email Inquiries'  ) /* for resurrected leads from email */ /* for resurrected leads from email */
					 OR	(latest_lead_medium  = 'website - chat wa'
					 AND	created_time  <= date_add('day', -33, latest_nurturing_date)) /* for resurrected leads from WABA with created date min. 33 days before Latest Nurturing Date */
)
					 AND	date_format(case
							 when (lower(lead_source_sales)  not like '%trial%'
							 OR	lower(lead_source_sales)  not like '%web demo%')
							 AND	lower(lead_source_sales)  not like '%inquir%'
							 AND	lower(lead_source_detail)  like '%manual%update%' then date(date_parse(substr(lead_source_detail,1, 6), '%y%m%d'))
							 else created_time
						 end, '%Y%m')  != date_format(latest_nurturing_date, '%Y%m') then null
					 else meeting_status
				 end/* to prevent double count SQL */ meeting_status,
			 case
					 when (latest_form_name  in ( 'Resurrected Leads'  , 'Email Nurturing Inquiry Form'  ) /* for resurrected leads */ /* for resurrected leads */
					 OR	((lower(latest_lead_source_detail)  like '%51253]%' /* for resurrected leads from change software campaign */ OR	lower(latest_lead_source_detail)  like '(01e)%')
					 AND	created_time  <= date_add('day', -33, latest_nurturing_date)) /* for resurrected leads from change software campaign */ OR	latest_lead_source_sales  in ( 'Inbound - Marketing Digital Email Inquiries'  , 'Inbound - Email Inquiries'  ) /* for resurrected leads from email */ /* for resurrected leads from email */
					 OR	(latest_lead_medium  = 'website - chat wa'
					 AND	created_time  <= date_add('day', -33, latest_nurturing_date)) /* for resurrected leads from WABA with created date min. 33 days before Latest Nurturing Date */
)
					 AND	date_format(case
							 when (lower(lead_source_sales)  not like '%trial%'
							 OR	lower(lead_source_sales)  not like '%web demo%')
							 AND	lower(lead_source_sales)  not like '%inquir%'
							 AND	lower(lead_source_detail)  like '%manual%update%' then date(date_parse(substr(lead_source_detail,1, 6), '%y%m%d'))
							 else created_time
						 end, '%Y%m')  != date_format(latest_nurturing_date, '%Y%m') then null
					 else coalesce(tele_assign_date, payment_closing_date)
				 end/* to prevent double count SQL */ tele_assign_date,
				case
					 when (latest_form_name  in ( 'Resurrected Leads'  , 'Email Nurturing Inquiry Form'  ) /* for resurrected leads */ /* for resurrected leads */
					 OR	((lower(latest_lead_source_detail)  like '%51253]%' /* for resurrected leads from change software campaign */ OR	lower(latest_lead_source_detail)  like '(01e)%')
					 AND	created_time  <= date_add('day', -33, latest_nurturing_date)) /* for resurrected leads from change software campaign */ OR	latest_lead_source_sales  in ( 'Inbound - Marketing Digital Email Inquiries'  , 'Inbound - Email Inquiries'  ) /* for resurrected leads from email */ /* for resurrected leads from email */
					 OR	(latest_lead_medium  = 'website - chat wa'
					 AND	created_time  <= date_add('day', -33, latest_nurturing_date)) /* for resurrected leads from WABA with created date min. 33 days before Latest Nurturing Date */
)
					 AND	date_format(case
							 when (lower(lead_source_sales)  not like '%trial%'
							 OR	lower(lead_source_sales)  not like '%web demo%')
							 AND	lower(lead_source_sales)  not like '%inquir%'
							 AND	lower(lead_source_detail)  like '%manual%update%' then date(date_parse(substr(lead_source_detail, 1,6), '%y%m%d'))
							 else created_time
						 end, '%Y%m')  != date_format(latest_nurturing_date, '%Y%m') then null
					 else payment_closing_date
				 end/* to prevent double count Won */ payment_closing_date,
			 (
				Case
					 when form_name  in ( 'Talenta Starter from Paying Users Jurnal'  )
					 AND	contract_length  is not null then (contract_amount / contract_length)
					 when form_name  in ( 'Talenta Starter from Paying Users Jurnal'  )
					 AND	contract_length  is null then (contract_amount / 12)
					 else quotation_mrr
				 end) quotation_mrr,
			 mrr_after_disc,
			 contract_length,
			 contract_amount,
			 go_live_date,
			contract_start_dat as full_start_date,
			 id,
			contract_end_dat as full_end_date,
			 latest_contract_end_date as new_contract_end_date,
			 product_package,
			 referral_code,
			 latest_nurturing_date,
			 latest_form_name,
			 latest_lead_source,
			 latest_lead_medium,
			 latest_lead_source_detail,
			 case
					 when (replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '[%.%'
					 AND	split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '.', 1)  in ( 't2a'  , 't3a'  , 't4e'  ))
					 OR	(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '%.%]%'
					 AND	split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '.',1)  in ( 't2a'  , 't3a'  , 't4e'  ))
					 or split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 THEN replace(latest_lead_source, 'utm_source=', '')
					 ELSE replace(lead_source, 'utm_source=', '')
				 END lead_source_blended, 
			 case
					 when (replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '[%.%'
					 AND	split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '.', 1)  in ( 't2a'  , 't3a'  , 't4e'  ))
					 OR	(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '%.%]%'
					 AND	split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '.',1)  in ( 't2a'  , 't3a'  , 't4e'  ))
					 or split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 THEN replace(latest_lead_medium, 'utm_medium=', '')
					 ELSE replace(lead_medium, 'utm_medium=', '')
				 END lead_medium_blended, 
			 case
					 when (replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '[%.%'
					 AND	split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '.', 1)  in ( 't2a'  , 't3a'  , 't4e'  ))
					 OR	(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '%.%]%'
					 AND	split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '.',1)  in ( 't2a'  , 't3a'  , 't4e'  ))
					 or split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 THEN replace(replace(replace(replace(latest_lead_source_detail, 'utm_campaign=', ''), 'utm_term=', ''), 'journey_at=', ''), 'matchtype=', '')
					 ELSE replace(replace(replace(replace(lead_source_detail, 'utm_campaign=', ''), 'utm_term=', ''), 'journey_at=', ''), 'matchtype=', '')
				 END lead_source_detail_blended, 
			 case when (replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '[%.%'
					 AND	split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '.', 1)  in ( 't2a'  , 't3a'  , 't4e'  ))
					 OR	(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '%.%]%'
					 AND	split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '.',1)  in ( 't2a'  , 't3a'  , 't4e'  ))
					 or split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 THEN latest_lead_source_sales
					 ELSE lead_source_sales
				 END lead_source_sales_blended, 
			waba_utm_medium,
			 case when replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '[%.%'
					 AND	split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '.', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					  AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then substr(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '.',1),1, 3)
				  when	replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '%.%]%'
					 AND	split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '.',1)  in ( 't2a'  , 't3a'  , 't4e'  )
					  AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then substr(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '.',1),1, 3)
					 when split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then (substr(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-',1),1, 3))
					 when replace(coalesce(lead_source_detail, '-'), ' ', '')  like '[%.%' then substr(split_part(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '.',1),1, 3)
					 when replace(coalesce(lead_source_detail, '-'), ' ', '')  like '%.%]%' then substr(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '.',1),1, 3)
					 else (substr(split_part(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-',1),1, 3))
				 end channel_code, 
			  case when replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '[%.%'
					 AND	split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '.', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					  AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then substr(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '.',1),4, 2)
				  when	replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '%.%]%'
					 AND	split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '.',1)  in ( 't2a'  , 't3a'  , 't4e'  )
					  AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then substr(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '.',1),4, 2)
					 when split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then (substring(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-',1), 4, 2))
					 when replace(coalesce(lead_source_detail, '-'), ' ', '')  like '[%.%' then substr(split_part(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '.',1),4, 2)
					 when replace(coalesce(lead_source_detail, '-'), ' ', '')  like '%.%]%' then substr(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '.',1),4, 2)
					 else (substring(split_part(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-',1), 4, 2))
				 end campaign_code, 
			  case when length(split_part(split_part(lower(replace(coalesce(lead_source_detail, '-'), ' ', '')), '[',2), '-',1))  = 3 then concat(split_part(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-', 2), substring(replace(lead_source_detail, ' ', ''), 2, 1))
					 when split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then (
						case
							 when latest_lead_source_detail  like '(%' then coalesce(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[', 2), ']', 1), '-', 2), split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '(',2), ')',1))
							 else coalesce(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-', 2), substring(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), 6, length(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1)) -6))
						 end)
					 else (
						case
							 when lead_source_detail  like '(%' then coalesce(split_part(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-', 2), split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '(',2), ')',1))
							 else coalesce(split_part(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-', 2), substring(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), 6, length(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1)) -6))
						 end)
				 end post_id, 
			 case when split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then (
						case
							 when latest_lead_source_detail  like '(%' then null
							 else coalesce(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '(',2), ')',1), substring(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-',1), -1,1))
						 end)
			 else (
						case
							 when lead_source_detail  like '(%' then null
							 else coalesce(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '(',2), ')',1), substring(split_part(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-',1), -1, 1))
						 end)
				 end device_code, 
				/*update by agnes 20221026 due to matchtype result*/
				case when split_part(split_part(lower(replace(coalesce(latest_lead_source_detail , '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then (
						case
							 when lower(latest_lead_source_detail)  like '%~%mekari%' then concat(coalesce(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~',2)), 'm')
							 when lower(latest_lead_source_detail)  like '%~%t%'
							 OR	lower(latest_lead_source_detail)  like '%~%j%' then coalesce(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2))
							 else concat(coalesce(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2)), 't')
						 end)
					 else (
						case
							 when lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%mekari%' then concat(coalesce(split_part(split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2)), 'm')
							 when lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%t%'
							 OR	lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%j%' then coalesce(split_part(split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2))
							 when form_name  in ( 'Jurnal - Post Inquiry Multi Product'  )
							 OR	lower(replace(lead_source_detail, 'Cat ID', ''))  like 'jurnal - post inquiry multi product%' then concat(coalesce(split_part(split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2)), 'j')
							 else concat(coalesce(split_part(split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2)), 't')
						 end)
				 end landing_page, 
			 case when split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then (
						case
							 when CARDINALITY(REGEXP_EXTRACT_ALL(split_part(latest_lead_source_detail, '~', 2), '\|'))  >= 2 then (
								case
									 when lower(latest_lead_source_detail)  like '%~%mekari%' then concat(element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -3), 'm')
									 when lower(latest_lead_source_detail)  like '%~%t%'
									 OR	lower(latest_lead_source_detail)  like '%~%j%' then element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -3)
									 else concat(element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -3), 't')
								 end)
							 else '-'
						 end)
					 else (
						case
							 when CARDINALITY(REGEXP_EXTRACT_ALL(split_part(lead_source_detail, '~', 2), '\|'))  >= 2 then (
								case
									 when lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%mekari%' then concat(element_at(split(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|' ), -3), 'm')
									 when lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%t%'
									 OR	lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%j%' then element_at(split(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|' ), -3)
									 when form_name  in ( 'Jurnal - Post Inquiry Multi Product'  )
									 OR	lower(replace(lead_source_detail, 'Cat ID', ''))  like 'jurnal - post inquiry multi product%' then concat(element_at(split(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|' ), -3), 'j')
									 else concat(element_at(split(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|' ), -3), 't')
								 end)
							 else '-'
						 end)
				 end goal_previous_step_2, 
			 case
					 when split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then (
						case
							 when CARDINALITY(REGEXP_EXTRACT_ALL(split_part(latest_lead_source_detail, '~', 2), '\|'))  >= 1 then (
								case
									 when lower(latest_lead_source_detail)  like '%~%mekari%' then concat(element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2), 'm')
									 when lower(latest_lead_source_detail)  like '%~%t%'
									 OR	lower(latest_lead_source_detail)  like '%~%j%' then element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2)
									 else concat(element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2), 't')
								 end)
							 else '-'
						 end)
					 else (
						case
							 when CARDINALITY(REGEXP_EXTRACT_ALL(split_part(lead_source_detail, '~', 2), '\|'))  >= 1 then (
								case
									 when lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%mekari%' then concat(element_at(split(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2), 'm')
									 when lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%t%'
									 OR	lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%j%' then element_at(split(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2)
									 when form_name  in ( 'Jurnal - Post Inquiry Multi Product'  )
									 OR	lower(replace(lead_source_detail, 'Cat ID', ''))  like 'jurnal - post inquiry multi product%' then concat(element_at(split(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2), 'j')
									 else concat(element_at(split(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2), 't')
								 end)
							 else '-'
						 end)
				 end goal_previous_step_1, 
			 case when split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then (
						case
							 when lower(latest_lead_source_detail)  like '%~%mekari%' then concat(element_at(split(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1), 'm')
							 when lower(latest_lead_source_detail)  like '%~%t%'
							 OR	lower(latest_lead_source_detail)  like '%~%j%' then element_at(split(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1)
							 else concat(element_at(split(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1), 't')
						 end)
					 else (
						case
							 when lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%mekari%' then concat(element_at(split(split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1), 'm')
							 when lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%t%'
							 OR	lower(replace(lead_source_detail, 'Cat ID', ''))  like '%~%j%' then element_at(split(split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1)
							 when form_name  in ( 'Jurnal - Post Inquiry Multi Product'  )
							 OR	lower(replace(lead_source_detail, 'Cat ID', ''))  like 'jurnal - post inquiry multi product%' then concat(element_at(split(split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1), 'j')
							 else concat(element_at(split(split_part(replace(replace(replace(lower(lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1), 't')
						 end)
				 end completion_location, 
			  case when split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '-', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then latest_form_name
					 else form_name
				 end form_name_blended,
			 mkt_device_type,
			 telesales_notes,
			 sales_notes,
			 mql_drop_date,
			 case
					 when split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[', 2), '.', 1)  in ( 't2a'  , 't3a'  , 't4e'  )
					 AND	lower(coalesce(lead_medium, '-'))  not in ( 'google ads - search'  , '(i) google ads - search'  , 'google search'  )
					 AND	date_diff('day',latest_nurturing_date, created_time)  <= 7 then cast(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '.',2), ']',1) as varchar)
					 else cast(split_part(split_part(replace(replace(replace(lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '.',2), ']',1) as varchar)
				 end short,
			 owner as talenta_owner,
			 case when lead_source_detail like '%~%T%|%' and length(split_part(split_part(lead_source_detail, 'T',2), '|',1)) =8 and regexp_like(split_part(split_part(lead_source_detail, 'T',2), '|',1), '^-?\d+$') then DATE_PARSE(concat(substr(split_part(split_part(lead_source_detail, 'T',2), '|',1),3,2),'/',substr(split_part(split_part(lead_source_detail, 'T',2), '|',1),1,2),'/',cast(year(created_time) as varchar),' ',substr(split_part(split_part(lead_source_detail, 'T',2), '|',1),5,2),':', substr(split_part(split_part(lead_source_detail, 'T',2), '|',1),7,2)),'%d/%m/%Y %H:%i')
when lead_source_detail like '%~%T%' and length(split_part(lead_source_detail, 'T',2)) =8 and regexp_like(split_part(lead_source_detail, 'T',2), '^-?\d+$') then DATE_PARSE(concat(substr(split_part(lead_source_detail, 'T', 2),3,2),'/',substr(split_part(lead_source_detail, 'T', 2),1,2),'/',cast(year(created_time) as varchar),' ',substr(split_part(lead_source_detail, 'T', 2),5,2),':', substr(split_part(lead_source_detail, 'T', 2),7,2)),'%d/%m/%Y %H:%i')
else null end first_visited_timestamp,
no_deal_status
	FROM  "prod-datalake-zohotalenta-uniqueid".deals  
	WHERE	 coalesce(lead_source_detail, '-')  != 'Attendance Sunset'
	 AND	coalesce(form_name, '-')  != 'Talenta - Post Inquiry Multi Product'
	 AND	lower(coalesce(telesales_notes, '-'))  not like '%post inquiry multi product%' /* WHERE (LEFT(created_time, 16)  != LEFT("Latest Nurturing Date", 16) assuming same date hour minute meands create new leads from resurrected form OR	"Latest Nurturing Date"  IS NULL) */
    UNION ALL
 	SELECT
			 latest_nurturing_date leads_created_time,
			  CASE WHEN created_time  IS NOT NULL THEN 'Yes'
					 ELSE 'Yes'
				 END is_recycle,
			 created_time,
			 registered_time,
			 modified_time,
			 company_id,
			 demo_company_id,
			 deal_name as talenta_name,
			 pic_name,
			 pic_phone,
			 is_subsidiary_of_holding_company as is_part_of_holding_group,
			 holding_group_name,
			 current_system_integrator,
			 platform_revenue,
			 email,
			 pic_email as pic_email_hrd,
			 lead_origin,
			 lead_type,
			 lead_sub_type,
			 lead_channel,
			 form_name,
			 '-' complementary_product,
			 latest_nurturing_date as first_lead_status_updated,
			 latest_nurturing_date as last_lead_status_updated,
			 latest_lead_status as lead_status,
			 latest_lead_result as lead_result,
			 product_name,
			 no_of_employees,
			 employee_size_category,
			 employee_size_grouping,
			  case when no_of_employees  > 700 then 'Enterprise'
					 when no_of_employees  between 301  AND  700 then 'Large'
					 when no_of_employees  between 101  AND  300 then 'Mid'
					 when no_of_employees  between 51  AND  100 then 'Small'
					 when no_of_employees  <= 50 then 'Micro'
					 when lower(employee_size_category)  like '%enterprise%' then 'Enterprise'
					 when lower(employee_size_category)  like '%large%' then 'Large'
					 when lower(employee_size_category)  like '%medium%'
					 OR	lower(employee_size_category)  like '%big %' then 'Mid'
					 when lower(employee_size_category)  like '%small%' then 'Small'
					 when lower(employee_size_category)  like '%micro%' then 'Micro'
					 else '(undefined)'
				 end company_segment,
			 telesales_inbound,
			 telesales_outbound,
			 stage,
			 gclid,
			 case
					 when mkt_gclid  like '%|%' then split_part(mkt_gclid, '|',1)
					 else mkt_gclid
				 end mkt_gclid,
			case
					 when length(split_part(mkt_gclid, '|',2))  > 1 then split_part(mkt_gclid, '|',2)
					 else '-'
				 end msclkid,
			 cookie_id,
			 city_state,
			  case when replace(lower(city_state), ' ', '')  like '%,jakar%'
					 OR	replace(lower(city_state), ' ', '')  like '%,%bekasi%'
					 OR	replace(lower(city_state), ' ', '')  like '%,%tangeran%' then split_part(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(lower(city_state), ' ', ''), 'kabupaten', ''), 'kota', ''), 'kab.', ''), 'tangeranselatan', 'tangerangselatan'), 'jakarata', 'jakarta'), 'jakaratimur', 'jakartatimur'), 'jakarat', 'jakarta'), 'jaksel', 'jakartaselatan'), 'cikarang', 'bekasi'), 'tanggerang', 'tangerang'), 'regency', ''), 'sby', 'surabaya'), 'gersik', 'gresik'), 'diyogyakarta', 'yogyakarta'), 'diy', 'yogyakarta'), 'ypgyakarta', 'yogyakarta'), 'daerahistimewa', ''), 'distro', ''), 'pt.masarijaya', ''), 'kabsleman', 'sleman'), ',', 2)
					 when replace(lower(city_state), ' ', '')  like '%,%' then split_part(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(lower(city_state), ' ', ''), 'kabupaten', ''), 'kota', ''), 'kab.', ''), 'tangeranselatan', 'tangerangselatan'), 'jakarata', 'jakarta'), 'jakaratimur', 'jakartatimur'), 'jakarat', 'jakarta'), 'jaksel', 'jakartaselatan'), 'cikarang', 'bekasi'), 'tanggerang', 'tangerang'), 'regency', ''), 'sby', 'surabaya'), 'gersik', 'gresik'), 'diyogyakarta', 'yogyakarta'), 'diy', 'yogyakarta'), 'ypgyakarta', 'yogyakarta'), 'daerahistimewa', ''), 'distro', ''), 'pt.masarijaya', ''), 'kabsleman', 'sleman'), ',', 1)
					 else replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(lower(city_state), ' ', ''), 'kabupaten', ''), 'kota', ''), 'kab.', ''), 'tangeranselatan', 'tangerangselatan'), 'jakarata', 'jakarta'), 'jakaratimur', 'jakartatimur'), 'jakarat', 'jakarta'), 'jaksel', 'jakartaselatan'), 'cikarang', 'bekasi'), 'tanggerang', 'tangerang'), 'regency', ''), 'sby', 'surabaya'), 'gersik', 'gresik'), 'diyogyakarta', 'yogyakarta'), 'diy', 'yogyakarta'), 'ypgyakarta', 'yogyakarta'), 'daerahistimewa', ''), 'distro', ''), 'pt.masarijaya', ''), 'kabsleman', 'sleman')
				 end city_state_lowerstate,
			 industry,
			 industry_group,
			  CASE WHEN date_add('day', 33, coalesce(sales_meeting_date, payment_closing_date))  < latest_nurturing_date THEN NULL
					 ELSE sales_meeting_date
				 END sales_meeting_date,
			  CASE WHEN date_add('day', 33, coalesce(sales_meeting_date, payment_closing_date))  < latest_nurturing_date THEN '-'
					 ELSE meeting_status
				 END meeting_status,
			  CASE WHEN date_add('day', 33, coalesce(tele_assign_date, payment_closing_date))  < latest_nurturing_date THEN NULL
					 ELSE tele_assign_date
				 END tele_assign_date,
			  CASE WHEN date_add('day', 33, payment_closing_date)  < latest_nurturing_date THEN NULL
					 ELSE payment_closing_date
				 END payment_closing_date,
			 (
				Case
					 when form_name  in ( 'Talenta Starter from Paying Users Jurnal'  )
					 AND	contract_length  is not null then (contract_amount / contract_length)
					 else quotation_mrr
				 end) as quotation_mrr,
			 mrr_after_disc mrr_after_disc,
			 contract_length contract_length,
			 contract_amount contract_amount,
			 go_live_date go_live_date,
			 contract_start_dat as full_start_date,
			 id,
			contract_end_dat as full_end_date,
			 latest_contract_end_date as new_contract_end_date,
			 product_package,
			 referral_code,
			 latest_nurturing_date,
			 latest_form_name,
			 latest_lead_source,
			 latest_lead_medium,
			 latest_lead_source_detail,
			 latest_lead_source lead_source_blended, 
			 latest_lead_medium lead_medium_blended, 
			 latest_lead_source_detail lead_source_detail_blended, 
			 latest_lead_source_sales lead_source_sales_blended, 
			 waba_utm_medium,
			 case when replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '[%.%' then substr(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '.',1),1, 3)
				  when replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '%.%]%' then substr(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '.',1),1, 3)
				  else (substr(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-',1),1, 3)) end channel_code, 
			 case when replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '[%.%' then substr(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '.',1),4, 2)
					 when replace(coalesce(latest_lead_source_detail, '-'), ' ', '')  like '%.%]%' then substr(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '.',1),4, 2)
					 else (substring(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-',1), 4, 2)) end campaign_code, 
			  case when length(split_part(split_part(lower(replace(coalesce(latest_lead_source_detail, '-'), ' ', '')), '[',2), '-',1))  = 3 then concat(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-', 2), substring(replace(latest_lead_source_detail, ' ', ''), 2, 1)) 
			  when latest_lead_source_detail  like '(%' then coalesce(element_at(split(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-'), -1), split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '(',2), ')',1))
					 else coalesce(element_at(split(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-'), -1), substring(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), 6, length(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1)) -6))
				 end post_id, 
			  case when latest_lead_source_detail  like '(%' then '-'
					 else coalesce(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '(',2), ')',1), substr(split_part(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '[',2), ']',1), '-',1), -1,1))
				 end device_code,  
				/*update by agnes 20221026 due to matchtype result*/
				case when length(split_part(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~',2), '|',1), 't', 2))  >= 7 then concat(split_part(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~',2), '|',1), 't', 1), 't')
					 when length(split_part(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~',2), '|',1), 'm', 2))  >= 7 then concat(split_part(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~',2), '|',1), 'm', 1), 'm')
					 when lower(latest_lead_source_detail)  like '%~%mekari%' then concat(coalesce(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2)), 'm')
					 when lower(latest_lead_source_detail)  like '%~%t%'
					 OR	lower(latest_lead_source_detail)  like '%~%j%' then coalesce(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2))
					 when latest_form_name  in ( 'Jurnal - Post Inquiry Multi Product'  )
					 OR	lower(latest_lead_source_detail)  like 'jurnal - post inquiry multi product%' then concat(coalesce(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2)), 'j')
					 else concat(coalesce(split_part(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|', 1), split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2)), 't')
				 end landing_page, 
			  case when CARDINALITY(REGEXP_EXTRACT_ALL(split_part(latest_lead_source_detail, '~', 2), '\|'))  >= 2 then (
						case
							 when lower(latest_lead_source_detail)  like '%~%mekari%' then concat(element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -3), 'm')
							 when lower(latest_lead_source_detail)  like '%~%t%'
							 OR	lower(latest_lead_source_detail)  like '%~%j%' then element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -3)
							 when latest_form_name  in ( 'Jurnal - Post Inquiry Multi Product'  )
							 OR	lower(latest_lead_source_detail)  like 'jurnal - post inquiry multi product%' then concat(element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -3), 'j')
							 else concat(element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -3), 't')
						 end)
					 else '-'
				 end goal_previous_step_2, 
				case
					 when CARDINALITY(REGEXP_EXTRACT_ALL(split_part(latest_lead_source_detail, '~', 2), '\|'))  >= 1 then (
						case
							 when lower(latest_lead_source_detail)  like '%~%mekari%' then concat(element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2), 'm')
							 when lower(latest_lead_source_detail)  like '%~%t%'
							 OR	lower(latest_lead_source_detail)  like '%~%j%' then element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2)
							 when latest_form_name  in ( 'Jurnal - Post Inquiry Multi Product'  )
							 OR	lower(latest_lead_source_detail)  like 'jurnal - post inquiry multi product%' then concat(element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2), 'j')
							 else concat(element_at(split(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '|'), -2), 't')
						 end)
					 else '-'
				 end goal_previous_step_1, 
			  case  when lower(latest_lead_source_detail)  like '%~%mekari%' then concat(element_at(split(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1), 'm')
					 when lower(latest_lead_source_detail)  like '%~%t%'
					 OR	lower(latest_lead_source_detail)  like '%~%j%' then element_at(split(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1)
					 when latest_form_name  in ( 'Jurnal - Post Inquiry Multi Product'  )
					 OR	lower(latest_lead_source_detail)  like 'jurnal - post inquiry multi product%' then concat(element_at(split(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1), 'j')
					 else concat(element_at(split(split_part(replace(replace(replace(lower(latest_lead_source_detail), ' ', ''), 'blog', ''), 'p', ''), '~', 2), '|'), -1), 't')
				 end completion_location,
			 latest_form_name form_name_blended,
			 mkt_device_type,
			 telesales_notes,
			 sales_notes,
		mql_drop_date,
		cast(split_part(split_part(replace(replace(replace(latest_lead_source_detail, ' ', ''), 'Blog', ''), '-B', ''), '.',2), ']',1) as varchar) short,
		owner as talenta_owner,
		case when latest_lead_source_detail like '%~%T%|%' and length(split_part(split_part(latest_lead_source_detail, 'T',2), '|',1)) =8 and regexp_like(split_part(split_part(latest_lead_source_detail, 'T',2), '|',1), '^-?\d+$')  then DATE_PARSE(concat(substr(split_part(split_part(latest_lead_source_detail, 'T',2), '|',1),3,2),'/',substr(split_part(split_part(latest_lead_source_detail, 'T',2), '|',1),1,2),'/',cast(year(created_time) as varchar),' ',substr(split_part(split_part(latest_lead_source_detail, 'T',2), '|',1),5,2),':', substr(split_part(split_part(latest_lead_source_detail, 'T',2), '|',1),7,2)),'%d/%m/%Y %H:%i')
when latest_lead_source_detail like '%~%T%' and length(split_part(latest_lead_source_detail, 'T',2)) =8 and regexp_like(split_part(latest_lead_source_detail, 'T',2), '^-?\d+$') then DATE_PARSE(concat(substr(split_part(latest_lead_source_detail, 'T', 2),3,2),'/',substr(split_part(latest_lead_source_detail, 'T', 2),1,2),'/',cast(year(created_time) as varchar),' ',substr(split_part(latest_lead_source_detail, 'T', 2),5,2),':', substr(split_part(latest_lead_source_detail, 'T', 2),7,2)),'%d/%m/%Y %H:%i')
else null end first_visited_timestamp,
no_deal_status
	FROM  "prod-datalake-zohotalenta-uniqueid".deals 
	WHERE	 (latest_form_name  in ( 'Resurrected Leads'  , 'Email Nurturing Inquiry Form'  ) /* for resurrected leads */ /* for resurrected leads */
	 OR	((lower(latest_lead_source_detail)  like '%51253]%' /* for resurrected leads from change software campaign */
 OR	lower(latest_lead_source_detail)  like '(01e)%')
	 AND	created_time  <= date_add('day', -33, latest_nurturing_date)) /* for resurrected leads from change software campaign */ OR	latest_lead_source_sales  in ( 'Inbound - Marketing Digital Email Inquiries'  , 'Inbound - Email Inquiries'  ) /* for resurrected leads from email */ /* for resurrected leads from email */
	 OR	(latest_lead_medium  = 'website - chat wa'
	 AND	created_time  <= date_add('day', -33, latest_nurturing_date)) /* for resurrected leads from WABA with created date min. 33 days before Latest Nurturing Date */
)
	 AND	date_format(case when (lower(lead_source_sales)  not like '%trial%' OR	lower(lead_source_sales)  not like '%web demo%')
			 AND	lower(lead_source_sales)  not like '%inquir%'
			 AND	lower(lead_source_detail)  like '%manual%update%' then date(date_parse(substr(lead_source_detail,1, 6), '%y%m%d'))
			 else created_time
		 end,'%Y%m')  != date_format(latest_nurturing_date,'%Y%m')) a
left join "prod-datalake-gsheet-marketing-analytics-uniqueid".waba_medium_code_all_tribe b on a.channel_code = b.wa_code
LEFT JOIN(	SELECT
			 row_number() over(PARTITION BY short , ip_address , year(date_parse(added_time, '%d-%M-%Y %T'))  ORDER BY coalesce(date_parse(added_time, '%d-%M-%Y %T'), date_parse('1900-12-31', '%Y-%m-%d')) DESC ) row_number,
			 *,
			 'T' as tribe,
			 case when length(split_part(split_part(replace(upper(journey),'CATID',''),'T',2),'|',1))>0 then concat(split_part(replace(replace(replace(upper(journey),'CATID',''), 'BLOG',''),' ',''), 'T',1),'T')
				  when journey like '%|%' and upper(journey) not like '%T%' then concat(split_part(replace(replace(replace(upper(journey),'CATID',''), 'BLOG',''),' ',''), '|',1),'T')
				  when journey like '%|%' then split_part(replace(replace(replace(upper(journey),'CATID',''), 'BLOG',''),' ',''), '|',1)
				else concat(split_part(replace(replace(upper(journey),'CATID',''), 'BLOG',''),'T',1),'T') end as first_journey_page,
			 case when journey like '%|%' then split_part(replace(replace(upper(journey), 'BLOG',''),' ',''), '|', 2)
				else  concat(split_part(replace(replace(upper(journey),'CATID',''), 'BLOG',''),'T',1),'T') end as last_journey_page,
			case when length(split_part(split_part(journey,'T',2),'|',1)) <> 8 or journey is null then null else 
			date_parse(concat(substr(split_part(split_part(upper(replace(journey,' ','')),'T',2),'|',1), 3, 2), '/', substr(split_part(split_part(upper(replace(journey,' ','')),'T',2),'|',1), 1, 2), '/', split_part(split_part(added_time,'-',3),' ',1), ' ', substr(split_part(split_part(upper(replace(journey,' ','')),'T',2),'|',1), 5, 2), ':', substr(split_part(split_part(upper(replace(journey,' ','')),'T',2),'|',1), 7, 2)), '%d/%m/%Y %H:%i') end as first_visited_timestamp,
			case
					 when gclid  like '%|%' then split_part(gclid, '|',1)
					 else gclid
				 end as gclid_,
			case
					 when length(split_part(gclid, '|',2))  > 1 then split_part(gclid, '|',2)
					 else null
				 end as msclkid_
	FROM  "prod-datalake-gsheet-marketing-analytics-uniqueid".talenta_gclid 
) l ON l.short  = a.short
	 AND	YEAR(date_parse(l.added_time, '%d-%M-%Y %T'))  = YEAR(a.leads_created_time)
	 AND	l.row_number  = 1
	 AND	l.tribe  = upper(substr(a.channel_code, 1,1)) 
LEFT JOIN(	SELECT
			 row_number() over(PARTITION BY short , ip_address , year(date_parse(added_time, '%d-%M-%Y %T'))  ORDER BY coalesce(date_parse(added_time, '%d-%M-%Y %T'), date_parse('1900-12-31', '%Y-%m-%d')) DESC ) row_number,
			 *,
			 'M' as tribe,
			 case when length(split_part(split_part(replace(upper(journey),'CATID',''),'M',2),'|',1))>0 then concat(split_part(replace(replace(replace(upper(journey),'CATID',''), 'BLOG',''),' ',''), 'M',1),'M')
				  when journey like '%|%' and upper(journey) not like '%M%' then concat(split_part(replace(replace(replace(upper(journey),'CATID',''), 'BLOG',''),' ',''), '|',1),'M')
				  when journey like '%|%' then split_part(replace(replace(replace(upper(journey),'CATID',''), 'BLOG',''),' ',''), '|',1)
				else concat(split_part(replace(replace(upper(journey),'CATID',''), 'BLOG',''),'M',1),'M') end as first_journey_page,
			 case when journey like '%|%' then split_part(replace(replace(upper(journey), 'BLOG',''),' ',''), '|', 2)
				else  concat(split_part(replace(replace(upper(journey),'CATID',''), 'BLOG',''),'M',1),'M') end as last_journey_page,
			case when length(split_part(split_part(journey,'M',2),'|',1)) <> 8 or journey is null then null else 
			date_parse(concat(substr(split_part(split_part(upper(replace(journey,' ','')),'M',2),'|',1), 3, 2), '/', substr(split_part(split_part(upper(replace(journey,' ','')),'M',2),'|',1), 1, 2), '/', split_part(split_part(added_time,'-',3),' ',1), ' ', substr(split_part(split_part(upper(replace(journey,' ','')),'M',2),'|',1), 5, 2), ':', substr(split_part(split_part(upper(replace(journey,' ','')),'M',2),'|',1), 7, 2)), '%d/%m/%Y %H:%i') end as first_visited_timestamp,
			case
					 when gclid  like '%|%' then split_part(gclid, '|',1)
					 else gclid
				 end as gclid_,
			case
					 when length(split_part(gclid, '|',2))  > 1 then split_part(gclid, '|',2)
					 else null
				 end as msclkid_
	FROM  "prod-datalake-gsheet-marketing-analytics-uniqueid".mekari_gclid 
) n ON n.short  = a.short
	 AND	YEAR(date_parse(n.added_time, '%d-%M-%Y %T'))  = YEAR(a.leads_created_time)
	 AND	n.row_number  = 1
	 AND	n.tribe  = upper(substr(a.channel_code, 1,1)) 
LEFT JOIN "prod-datalake-gsheet-marketing-analytics-uniqueid".waba_url_page_all_tribe c ON upper(coalesce(l.first_journey_page, concat(a.post_id, substr(a.channel_code, 1,1))))  = c.post_id 
LEFT JOIN "prod-datalake-gsheet-marketing-analytics-uniqueid".waba_campaign_direct_talenta d ON a.post_id  = d.code__t_ 
LEFT JOIN "prod-datalake-gsheet-marketing-analytics-uniqueid".waba_campaign_to_website_all_tribe e ON upper(concat(substr(a.channel_code, 1,1), a.campaign_code))  = e.campaign_code 
LEFT JOIN "prod-datalake-gsheet-marketing-analytics-uniqueid".waba_url_page_all_tribe f ON upper(coalesce(l.first_journey_page, n.first_journey_page, a.landing_page))  = f.post_id 
LEFT JOIN "prod-datalake-gsheet-marketing-analytics-uniqueid".waba_url_page_all_tribe g ON upper(a.goal_previous_step_2)  = g.post_id 
LEFT JOIN "prod-datalake-gsheet-marketing-analytics-uniqueid".waba_url_page_all_tribe h ON upper(a.goal_previous_step_1)  = h.post_id 
LEFT JOIN "prod-datalake-gsheet-marketing-analytics-uniqueid".waba_url_page_all_tribe i ON upper(coalesce(l.last_journey_page, n.last_journey_page, a.completion_location))  = i.post_id 
LEFT JOIN "prod-datalake-gsheet-marketing-analytics-uniqueid".waba_campaign_direct_all_tribe j ON upper(a.post_id)  = upper(j.code) 
LEFT JOIN "prod-datalake-gsheet-marketing-analytics-uniqueid".industry k ON lower(a.industry)  = lower(k.industry) 
LEFT JOIN "prod-datalake-gsheet-marketing-analytics-uniqueid".mkt_talenta_sql_keyword_organic m ON m.key  = concat(a.talenta_owner, date_format(a.leads_created_time, '%d/%m/%Y %H:%i:%s'))  
WHERE	 date_format(a.leads_created_time,'%Y-%m')  >= '2019-11'