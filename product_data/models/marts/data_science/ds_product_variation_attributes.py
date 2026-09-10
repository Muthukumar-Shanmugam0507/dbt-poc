def model(dbt, session):
    df = dbt.ref("stg_pdm__product_variation_attributes")
    df = df.drop("CREATED_AT")

    df = df.to_pandas()

    df = df.pivot_table(
        index=["PRODUCT_ID", "COLOR_ID"], columns="ATTRIBUTE_NAME", values="ATTRIBUTE_VALUE", aggfunc="first"
    ).reset_index()

    df = session.create_dataframe(df)
    return df
