select
    to_varchar(GIFTCARDID) as GIFT_CARD_ID
	, to_varchar(MFITEMID) as MF_ITEM_ID
	, to_varchar(BRANDID) as BRAND_ID
	, to_varchar(PRODUCTTYPEID) as PRODUCT_TYPE_ID
	, nullif(replace(trim(replace(replace(TITLE,'&amp;','&'), '&reg;','®')), chr(0), ''), '') as TITLE
	, nullif(replace(trim(DESCRIPTION), chr(0), ''), '') as DESCRIPTION
	, STATUS
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as UPDATED_AT
	, MODIFIEDBY as MODIFIED_BY
from
    {{source('FBB_GIFT_CARDS', 'GIFTCARD')}}