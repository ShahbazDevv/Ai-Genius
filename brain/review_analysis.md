# Static Analysis of products_v1.csv - Pre-Browser Review

## Duplicate image_url detections (strong SUSPICIOUS signal)

Row 6  (Professional All-In-One Bridal Makeup Gift Kit):     image=0be91db405626027c44243a7a9775f5c.jpg
Row 41 (FIRE Light 104-Key Mechanical Gaming Keyboard):      image=0be91db405626027c44243a7a9775f5c.jpg
→ SAME image for a makeup kit AND a gaming keyboard! At least one is wrong.

Row 32 (Kundan & Pearl Heritage Bridal Jewelry Set):         image=432095f6dc15560b73c4d9cb9c025095.jpg
Row 44 (Modern Running Horses Canvas Framed Wall Art):       image=432095f6dc15560b73c4d9cb9c025095.jpg
→ SAME image for jewelry AND canvas wall art.

Row 12 (Scents N Secrets I Love Oud Bath & Body Gift Box):  image=74ebff224959db62c974c83fc67fa091.jpg
Row 46 (Premium Pack of 4 Dry Fruits & Nuts Combo Box):     image=74ebff224959db62c974c83fc67fa091.jpg
→ SAME image for a bath/body gift and a dry fruits box.

Row 37 (Taimoor F Plus English Willow Cricket Bat):         image=5a2d6771cfd65ceb15cb27863bf18ca1.jpg
Row 45 (Nordic Geometric Deer Head Wall Mount):              image=5a2d6771cfd65ceb15cb27863bf18ca1.jpg
Row 49 (Hexagonal Wooden Dry Fruit Royal Hamper Box):       image=5a2d6771cfd65ceb15cb27863bf18ca1.jpg
→ THREE products sharing the same image: cricket bat, deer head sculpture, dry fruit hamper.

Row 16 (A4Tech HS-50 ComfortFit Stereo Headset):            image=5a2d6e386ce056dbe1267428f5c90ec9.jpg
Row 37 note: different image to cricket bat above... checking again.
  Row 16 image: 5a2d6e386ce056dbe1267428f5c90ec9.jpg  (different, ok)

Row 39 (PRO II RGB Gaming Headphones):                       image=16ee1b1ca29d107a61d15442dfa8fa5b.jpg
Row 47 (6-in-1 Dry Fruits & Nuts Gift Box 690g):             image=16ee1b1ca29d107a61d15442dfa8fa5b.jpg
→ SAME image for gaming headphones AND dry fruits box.

Row 38 (RGB 7-Color Gaming Mouse):                           image=bb430d85ef418728d10b7ee0c1a92358.jpg
Row 48 (Mix Dry Fruit 5-Sectional Gift Box 1 KG):            image=bb430d85ef418728d10b7ee0c1a92358.jpg
→ SAME image for gaming mouse AND dry fruits gift box.

## Row 18 - SUSPICIOUS: URL/product mismatch
Row 18 CSV name: "3-in-1 Mobile Gaming Accessories Bundle for PUBG Mobile"
CSV description says: "responsive triggers, precision capacitive stylus, and non-slip thumb sleeves"
But the store_url slug says: "high-quality-gaming-keyboard-and-mouse-combo-with-rgb-side-led-panel-mechanical-feeling-wired-keyboard-2400-dpi-mouse-with-free-mouse-pad-for-pubg-mobile..."
→ URL describes a keyboard+mouse combo, NOT mobile gaming triggers. The product URL does not match the claimed product. SUSPICIOUS.

## Price anomalies (round numbers that could be placeholder)
Row 9 (Miss Rose Vanity): price=10000 (round)
Row 13 (Remington PG180): price=9000 (round)
Row 17 (120W 10000mAh Power Bank): price=10000 (round)
Row 33 (Premium Gold-Plated Jewelry Set): price=9999
Row 41 (FIRE Light Keyboard): price=14000 (round)
Row 48 (Dry Fruit 1 KG): price=4000 (round)
→ Round numbers are possible but worth checking.

## Row 18 - category mismatch
Row 18 category_id=mobile_accessories_bundle but URL is clearly keyboard+mouse → WRONG product linked.

## Other observations
- Row 34 (Saki Sports Cricket Bat 2026): name says "2026" bat - year branding is unusual but possible for a sports product.
- Row 36 (SS TON 2023 Bat): URL slug says "2023" but name says "Professional Editions" - minor inconsistency.
- Row 41 image is same as Row 6 (Bridal Makeup Kit image). The makeup kit image on a gaming keyboard listing is very suspicious.
