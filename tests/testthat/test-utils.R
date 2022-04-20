library(pkEML)

test_that("null2na works as expected", {
  expect_equal(null2na(NULL), NA)
  expect_equal(null2na(list()), NA)
  expect_equal(null2na("    "), NA)
})

test_that("parse_packageId", {
  expect_equal(parse_packageId("knb-lter-ble.1.2"), list(scope = "knb-lter-ble", id = "1", rev = "2"))
  expect_equal(parse_packageId("doi:10.5063/F1K64GHT
"), list(scope = NA, id = "doi:10.5063/F1K64GHT
", rev = NA))
  expect_equal(parse_packageId("urn:uuid:6229a977-0986-4f1f-a8df-1d5101131eaf"), list(scope = NA, id = "urn:uuid:6229a977-0986-4f1f-a8df-1d5101131eaf", rev = NA))
})
