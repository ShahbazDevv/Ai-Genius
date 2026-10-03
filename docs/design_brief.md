# AI Genius: Design Brief

## Mood
Attractive, rich, premium, energetic but still clean. NOT sober, NOT plain, NOT generic. Deep purple world with bright yellow highlights.

## Color system

### Dark mode (main look)
- Background: a vertical gradient with TWO shades of deep purple: top #1A0B2E to bottom #34155E (a "double shade" feel). Optionally add a soft glowing purple blob (#6B2FBF at 25 percent opacity) behind the top area for depth.
- Card surface: #2A1250 with a thin border #4A2A80, slightly translucent. Soft glow shadow.
- Primary accent (yellow): #FFC93C. Pressed / hover / focused yellow: #FFB300. Soft yellow tint for backgrounds: #FFC93C at 15 percent opacity.
- Text on dark: primary #FFFFFF, secondary #CFC3E8, muted #9C8BBF.
- Text on yellow buttons: deep purple #1A0B2E (never white).
- Success #4ADE80, error #FF6B6B.

### Light mode
- Background: soft lavender gradient #F7F2FF to #E9DDFF.
- Card surface: white with border #E0D3F5 and soft purple-tinted shadow.
- Primary: deep purple #4B1D8F. Accent: the same yellow #FFC93C, pressed #FFB300.
- Text: primary #1A0B2E, secondary #5B4A7A, muted #8E7FAA.
- Text on yellow: #1A0B2E.
- Contrast rule: in Light mode, never use yellow (#FFC93C) as text color on white or lavender surfaces (poor readability). In Light mode, use deep purple #4B1D8F for prices, budget values, and highlighted text; yellow remains strictly for fill/background (selected chips, buttons, slider, badges) with deep purple text on top. In Dark mode, yellow text on purple surfaces is standard.

## Interaction states (very important)
- Mobile has no mouse hover, so "hover" means PRESSED / FOCUSED / SELECTED states and must be YELLOW.
- Selected chip: filled yellow #FFC93C with deep purple text, small check icon.
- Unselected chip: dark purple surface, thin purple border, light text.
- Pressed chip or button: darker yellow #FFB300 with a slight scale-down (0.97) animation.
- Primary button: yellow filled, rounded 16, subtle yellow glow shadow, deep purple bold text.
- Slider: yellow active track and yellow thumb with a glow, muted purple inactive track.
- Active bottom navigation item: yellow icon plus a small yellow pill indicator.
- Heart (save) icon: outline when not saved, filled yellow when saved.

## Typography
Font: Poppins (Google Fonts). Headings bold (700), body regular (400), buttons semi-bold (600). Large clear headings, comfortable spacing.

## Shape and spacing
Cards radius 20, chips radius 14, buttons radius 16. Screen padding 20. Gap between sections 16 to 20. Generous spacing, nothing cramped.

## Motion
Smooth and subtle: fade and slide-up on screen entry (250 to 350 ms), scale on press, animated chip selection, shimmer on loading. No heavy or distracting animation.

## AI symbol
A sparkle (4-point star) icon in yellow is used wherever AI is mentioned (logo, Analyze button, loading, results header).

## Screens

### 1. Splash
Full deep purple gradient. Centered logo (gift box with a yellow sparkle) with a soft yellow glow, app name "AI Genius" in bold white, tagline "Gifts, chosen by AI" in light lavender, slim yellow progress indicator at the bottom. Logo scales and fades in. Duration about 2 seconds, then go to Home.

### 2. Home (gift preferences form)
Top bar: small logo and "AI Genius" on the left, settings icon on the right.
Heading "Find the Perfect Gift" (large, bold) with a yellow sparkle. Subtext "Tell us about the person and AI Genius will suggest the best gifts."
The form is split into separate cards, each with a small yellow icon and title:
1. "Who is it for?" chips: Mother, Father, Friend, Best Friend, Partner, Brother, Sister, Teacher, Colleague, Other (single select)
2. "Age group" chips: 5-9, 10-19, 20-24, 25-29, 30-39, 40-49, 50+ (single select)
3. "Gender (optional)": Male, Female, Prefer not to say
4. "Occasion" chips: Birthday, Wedding, Anniversary, Graduation, Engagement, Thank You, Valentine's Day, Eid, Christmas, Other (single select)
5. "Budget": horizontal slider PKR 500 to PKR 15,000 (steps of 500). Selected value shown big and clear in yellow, like "Budget: PKR 3,500".
6. "Interests" (multi select, each chip with an icon): Beauty, Skincare, Makeup, Books, Technology, Computer Gadgets, Mobile Accessories, Sports, Cricket, Fitness, Fashion, Jewelry, Gaming, Travel, Home & Lifestyle, Food, Art & Crafts, Other
7. "Gift style" (multi select): Practical, Elegant, Luxury, Budget-Friendly, Personalized, Sentimental, Fun, Minimal, Self-Care, Experience
8. Optional text field "Anything else about this person?" (max 200 characters)
Sticky bottom button "Analyze Gifts" with a sparkle icon (yellow, full width). Disabled look until required fields (who, age, occasion, at least one interest) are filled. Disabled while analysis is running.
Bottom navigation: Home, Saved, History.

### 3. AI Loading
Deep purple gradient. Center: animated glowing yellow sparkle orb (pulsing rings). Below it, status text changing every 1 second: "Understanding the recipient...", "Matching interests...", "Checking your budget...", "Picking the best gifts...". Under that, a summary chip row of the user's choices (example: Mother · Birthday · PKR 3,500).

### 4. Results
Title "Your AI Gift Suggestions" with sparkle. Summary row of inputs at top. Exactly 4 large cards, each with: rank badge (yellow circle with number), category icon in a yellow-tinted circle, category name (example "Skincare Gift Set"), one-line reason (example "Matches skincare interest and birthday occasion."), a label "3 products within budget", a heart save button and a right arrow. Cards animate in one by one. Never show raw scores.
EMPTY state: friendly illustration/icon, text "No suitable gifts found within this budget", yellow button "Change budget".

### 5. Product list
Header with category title (example "Skincare Gift Set") and a yellow chip "Up to PKR 3,500". Filter and sort bar: Sort (Price low to high, Price high to low, Relevance), Availability filter. 2-column grid of product cards: image (rounded top), name (2 lines max), price in PKR in yellow, store name (example Daraz), 2 small tag chips, availability label (In stock in green), heart save button. Lazy loading list. Missing image shows a placeholder.
EMPTY state: "No products found".

### 6. Product detail
Large product image at top (rounded bottom corners), back button and heart button over the image. Below: product name, price in PKR (big, yellow), store name, availability badge, description, relevant tags as chips, source label (example "Source: Curated catalog"). Large yellow button "View on Store". Small note: "Price and availability may change on the store."

### 7. Saved gifts
List of saved products and categories with remove option. Label "Available offline". An old item can show a small warning "Link may no longer be valid". EMPTY state with message and a button to go Home.

### 8. History
List of past searches. Each item: title (example "Birthday Gift Search"), subtitle (example "Mother · Beauty · PKR 3,500"), date. Tap to reopen results. Swipe to delete. "Clear all" button with confirmation dialog. EMPTY state.

### 9. Settings
Theme selector (Light, Dark, System) as three selectable cards (selected one is yellow). App version. About section. Theme changes instantly without restart.

## Global rules
- All text readable with good contrast in both themes.
- Handle no-internet, error and empty states on every screen that needs them.
- Never overflow on small screens (360x640) or large screens.
- Reusable widgets for: primary button, card, selectable chip, section title, product card, category card, empty state.
