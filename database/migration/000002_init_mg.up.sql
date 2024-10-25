DROP FUNCTION IF EXISTS trigger_set_timestamp();

CREATE FUNCTION trigger_set_timestamp() 
RETURNS trigger AS $$
begin
  NEW.updated_at = NOW();
  return NEW;
end;
$$ language plpgsql;

ALTER TABLE books 
  ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), 
  ADD updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

ALTER TABLE users 
  ADD created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(), 
  ADD updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

CREATE TRIGGER set_timestamp
  BEFORE UPDATE ON books
  FOR EACH ROW
  EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER set_timestamp
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE PROCEDURE trigger_set_timestamp();

CREATE EXTENSION IF NOT EXISTS pgcrypto;

INSERT INTO users (id, email, password, username)
	VALUES
    ('88eaeab2-b50d-4bc6-87fa-20c6546f4d3d', 'avery.brown@gmail.com', crypt('avery123', gen_salt('bf', 12)), 'AveryBrown'),
    ('c7ac0041-e354-4787-b586-111a350f6229', 'charles.white@gmail.com', crypt('charles456', gen_salt('bf', 12)), 'CharlesWhite'),
    ('87285c50-55ac-401f-9202-945840a5503e', 'olivia.smith@gmail.com', crypt('olivia789', gen_salt('bf', 12)), 'OliviaSmith'),
    ('5d510106-5e1d-476b-94cc-6b30e60ea4bb', 'emma.johnson@gmail.com', crypt('emma1234', gen_salt('bf', 12)), 'EmmaJohnson'),
    ('e1e5d6e1-6596-485d-9e68-b1ad53b41295', 'liam.williams@gmail.com', crypt('liam5678', gen_salt('bf', 12)), 'LiamWilliams'),
    ('49ed3b2d-48f1-473e-a5a7-528d9ae2fadb', 'sophia.jones@gmail.com', crypt('sophia987', gen_salt('bf', 12)), 'SophiaJones'),
    ('d1fda8ae-1f83-42d3-94c6-f17d5ef92f27', 'isabella.brown@gmail.com', crypt('bella123', gen_salt('bf', 12)), 'IsabellaBrown'),
    ('25505c9b-c835-4e38-a031-dc74a2e1fa79', 'james.davis@gmail.com', crypt('james998', gen_salt('bf', 12)), 'JamesDavis'),
    ('504ae99e-24aa-45ae-bc92-34ad9da51282', 'noah.miller@gmail.com', crypt('noah777', gen_salt('bf', 12)), 'NoahMiller'),
    ('51b91ff5-b509-4e79-8764-6ef7a5bcdcc9', 'mia.martinez@gmail.com', crypt('mia1234', gen_salt('bf', 12)), 'MiaMartinez'),
    ('f38ef497-018e-48c9-87ed-e2f1669d88f5', 'lucas.moore@gmail.com', crypt('lucas4567', gen_salt('bf', 12)), 'LucasMoore'),
    ('e3ac9d3b-6da1-472e-80f1-cae9b9e7cb7c', 'ella.thomas@gmail.com', crypt('ella789', gen_salt('bf', 12)), 'EllaThomas'),
    ('03cc76f0-cc9f-49c5-b68d-08dbcf2457a3', 'benjamin.garcia@gmail.com', crypt('benji123', gen_salt('bf', 12)), 'BenjaminGarcia'),
    ('dd71f15c-179d-47cf-9631-4aa3db23df58', 'amelia.taylor@gmail.com', crypt('amelia987', gen_salt('bf', 12)), 'AmeliaTaylor'),
    ('b61725d3-b4ba-408a-b6f6-f86d50309b9f', 'logan.martin@gmail.com', crypt('logan987', gen_salt('bf', 12)), 'LoganMartin'),
    ('b5466ce0-2f48-4aa7-8153-278b7d6f6b14', 'harper.lee@gmail.com', crypt('harper123', gen_salt('bf', 12)), 'HarperLee'),
    ('2d2f4c50-476a-407d-9d4b-7aeb37b127ba', 'jackson.anderson@gmail.com', crypt('jackson456', gen_salt('bf', 12)), 'JacksonAnderson'),
    ('755a34e4-5e79-4e3a-95b3-e45695f96c56', 'grace.harris@gmail.com', crypt('grace789', gen_salt('bf', 12)), 'GraceHarris'),
    ('dd574212-2639-4dc9-94d0-d3ab6ec65098', 'ethan.walker@gmail.com', crypt('ethan123', gen_salt('bf', 12)), 'EthanWalker'),
    ('ea743f52-7580-4b3c-9b48-54d663c8f0d1', 'zoey.young@gmail.com', crypt('zoey456', gen_salt('bf', 12)), 'ZoeyYoung'),
    ('1dbb017f-b159-4b77-8f8b-95d0c8de569f', 'henry.king@gmail.com', crypt('henry987', gen_salt('bf', 12)), 'HenryKing'),
    ('a2b3cfb9-156b-46e4-bff5-dbc0c2421220', 'ava.wright@gmail.com', crypt('ava1234', gen_salt('bf', 12)), 'AvaWright'),
    ('b4b817f3-50fb-456f-84d3-cc6d5579fe18', 'jack.dixon@gmail.com', crypt('jack1234', gen_salt('bf', 12)), 'JackDixon'),
    ('24b2392c-bbdf-4e9e-b198-70e37c9e4184', 'mason.evans@gmail.com', crypt('mason567', gen_salt('bf', 12)), 'MasonEvans'),
    ('d65b1f8a-e6d3-4f2f-bc5a-9249ddc417f2', 'scarlett.baker@gmail.com', crypt('scarlett987', gen_salt('bf', 12)), 'ScarlettBaker'),
    ('d34bce95-b760-41b4-8421-e909c063a014', 'william.parker@gmail.com', crypt('william456', gen_salt('bf', 12)), 'WilliamParker'),
    ('8e7f17ed-0428-492d-8569-8a69c88d4c0f', 'hannah.campbell@gmail.com', crypt('hannah123', gen_salt('bf', 12)), 'HannahCampbell'),
    ('c4a06d6f-7422-4b11-a38e-6da36d9b20fe', 'alexander.mitchell@gmail.com', crypt('alex1234', gen_salt('bf', 12)), 'AlexanderMitchell'),
    ('0b9b5d6d-8dd1-434a-9b9e-96404bce04b1', 'ellie.hall@gmail.com', crypt('ellie456', gen_salt('bf', 12)), 'EllieHall'),
    ('7c1ff0d1-87f2-4342-bb4b-986b2058f834', 'daniel.adams@gmail.com', crypt('daniel789', gen_salt('bf', 12)), 'DanielAdams'),
    ('780b7c5f-675e-4740-8dd9-d0bfc0c60b23', 'sofia.roberts@gmail.com', crypt('sofia1234', gen_salt('bf', 12)), 'SofiaRoberts'),
    ('16b9a5cb-4a37-4bb6-8891-b6d84e6355f7', 'sebastian.clark@gmail.com', crypt('seb123', gen_salt('bf', 12)), 'SebastianClark'),
    ('28e3e06e-2e64-46bb-b20e-0a2e1f6cfd9c', 'chloe.carter@gmail.com', crypt('chloe987', gen_salt('bf', 12)), 'ChloeCarter'),
    ('ff9817ef-4092-482e-b6e4-80f7c38b4038', 'dylan.reed@gmail.com', crypt('dylan456', gen_salt('bf', 12)), 'DylanReed'),
    ('e9ab00ef-4235-4116-85fb-49e41b6313a9', 'natalie.murphy@gmail.com', crypt('natalie789', gen_salt('bf', 12)), 'NatalieMurphy'),
    ('5dd45d66-cbc2-4b4b-9df5-90a1d4293e60', 'leo.turner@gmail.com', crypt('leo123', gen_salt('bf', 12)), 'LeoTurner'),
    ('3f1fcfa8-4075-4912-9e80-fc6782df67fc', 'ellie.daniels@gmail.com', crypt('ellie456', gen_salt('bf', 12)), 'EllieDaniels'),
    ('0c0ac55f-416b-403a-81a6-bfbfe79f7a2a', 'michael.wright@gmail.com', crypt('michael1234', gen_salt('bf', 12)), 'MichaelWright'),
    ('33c3a98d-1e96-4e26-874a-5207058e3b82', 'victoria.hughes@gmail.com', crypt('victoria987', gen_salt('bf', 12)), 'VictoriaHughes'),
    ('21a8c670-ff4e-4385-a220-1e1f76831b8f', 'logan.wood@gmail.com', crypt('logan456', gen_salt('bf', 12)), 'LoganWood'),
    ('4c3bce67-cf1a-47ff-9c47-0e159d2410e5', 'madison.bell@gmail.com', crypt('madison987', gen_salt('bf', 12)), 'MadisonBell'),
    ('bafae9f6-76a5-4f66-b62a-73f275fd2469', 'elijah.james@gmail.com', crypt('elijah123', gen_salt('bf', 12)), 'ElijahJames'),
    ('86d3a215-82e2-4aa3-9d68-6be45a2e0ab0', 'zoe.brooks@gmail.com', crypt('zoe456', gen_salt('bf', 12)), 'ZoeBrooks'),
    ('85708033-344e-4180-8ef9-62dbb3cf22d1', 'joseph.hughes@gmail.com', crypt('joseph789', gen_salt('bf', 12)), 'JosephHughes'),
    ('aa2f1f7a-0cb5-4d4d-83aa-b5c7515c0e44', 'stella.cox@gmail.com', crypt('stella987', gen_salt('bf', 12)), 'StellaCox'),
    ('3fca256f-6b10-4be2-96f5-f02aa67c30bc', 'jacob.gray@gmail.com', crypt('jacob123', gen_salt('bf', 12)), 'JacobGray'),
    ('0f134f3c-2c64-4e6d-bef0-02df6e1c4fd0', 'luna.price@gmail.com', crypt('luna456', gen_salt('bf', 12)), 'LunaPrice'),
    ('83c6df2e-3b72-4dc8-b742-9a6c3c42d739', 'liam.patterson@gmail.com', crypt('liam789', gen_salt('bf', 12)), 'LiamPatterson'),
    ('d3b6f05f-7a8f-43db-9ab2-0984c1d93349', 'hannah.green@gmail.com', crypt('hannah1234', gen_salt('bf', 12)), 'HannahGreen'),
    ('b2a22e05-54ba-4c7b-bb36-46b54b511e9d', 'samuel.cook@gmail.com', crypt('samuel456', gen_salt('bf', 12)), 'SamuelCook'),
    ('28e03d43-e5c5-48c8-8b83-6569be0fbf3b', 'chloe.perry@gmail.com', crypt('chloe789', gen_salt('bf', 12)), 'ChloePerry'),
    ('0f1f49a6-8fa4-4db3-8150-5a98fbe0ff6c', 'owen.bryant@gmail.com', crypt('owen123', gen_salt('bf', 12)), 'OwenBryant'),
    ('fc031fae-0f5f-4715-b8d7-6ab4b5f0f366', 'isabella.foster@gmail.com', crypt('isabella456', gen_salt('bf', 12)), 'IsabellaFoster'),
    ('5fd785b0-fc58-41de-8a14-804a151dd8b3', 'oliver.ross@gmail.com', crypt('oliver789', gen_salt('bf', 12)), 'OliverRoss'),
    ('48dff9a9-6404-46ec-9155-6827c10e64eb', 'mia.stewart@gmail.com', crypt('mia123', gen_salt('bf', 12)), 'MiaStewart'),
    ('b26fe07b-0ee5-434e-bcc5-bff29973dc02', 'natalie.watson@gmail.com', crypt('natalie1234', gen_salt('bf', 12)), 'NatalieWatson'),
    ('8b1981cb-3454-4c9f-8c97-4d505925b6db', 'jackson.hill@gmail.com', crypt('jackson4567', gen_salt('bf', 12)), 'JacksonHill'),
    ('7798e08d-d5b3-4e4e-bfd9-0b1fc1d490ff', 'emily.ward@gmail.com', crypt('emily987', gen_salt('bf', 12)), 'EmilyWard'),
    ('25e92d50-8746-4f0b-873e-5f04e4d52f45', 'logan.scott@gmail.com', crypt('logan1234', gen_salt('bf', 12)), 'LoganScott'),
    ('1f1f1cb0-7fe4-4fc9-8722-13dc4763a3f0', 'zoey.cooper@gmail.com', crypt('zoey456', gen_salt('bf', 12)), 'ZoeyCooper');

INSERT INTO books (id, name, author, year, description, price)
  VALUES
    ('8c5b4d76-104a-411b-9abd-a51efa02e0b3', 'The Fellowship of the Ring', 'John Ronald Reuel Tolkien', 1954, 'The first part of the epic fantasy series, The Lord of the Rings, following the journey of the Fellowship to destroy the One Ring.', 11.99), 
    ('9f1e38e2-5e65-41ab-99f7-6d38299a1dcb', 'Enigma', NULL, 2000, NULL, 5.99),
    ('a746a611-314a-41e9-a7c2-788c2f187511', 'The Great Gatsby', 'F. Scott Fitzgerald', 1925, 'A portrayal of the Jazz Age and the American Dream, centered on the mysterious millionaire Jay Gatsby.', 10.99),
    ('b67f1f78-dc4f-4638-9363-7155fe087eb0', 'Silent Echoes', 'Marie Hartman', 2015, 'A thriller about a journalist uncovering a government conspiracy involving secret surveillance.', 12.49),
    ('cb82f120-4e2a-4bbf-8f33-657a8b63fa15', 'War and Peace', 'Leo Tolstoy', 1869, 'An epic novel set during Napoleon’s invasion of Russia, exploring the fates of several aristocratic families.', 14.99),
    ('f4d88c63-17fb-4c0f-8c38-8a8c23c967ba', 'The Lost City', NULL, 2019, 'An archeologist embarks on an adventure to find a mythical city deep in the Amazon rainforest.', 7.99),
    ('c6d131cf-bc5e-482d-a1e2-5db32168df65', 'Pride and Prejudice', 'Jane Austen', 1813, 'A romantic novel that explores the manners and misunderstandings of British gentry.', 8.99),
    ('d13eb543-6eb5-489a-83ae-810f45f4dc47', '1984', 'George Orwell', 1949, 'A dystopian novel depicting a totalitarian regime controlling citizens through surveillance and propaganda.', 9.99),
    ('be542aed-7d3b-4d46-8d0f-e5124769c9e5', 'The Midnight Library', 'Matt Haig', 2020, 'A novel about a woman given the chance to live alternate versions of her life.', 12.99),
    ('acd3420d-5f91-4c12-a6de-64a45ae3f2cf', 'Invisible Cities', 'Italo Calvino', 1972, NULL, 6.99),
    ('f845d05c-6ef0-4328-a2ba-4d87442f4ebf', 'Shadows of Tomorrow', NULL, 2018, 'A futuristic sci-fi novel about humanity’s battle for survival against an AI uprising.', 10.49),
    ('baf4fc6d-61e7-49e9-8db7-d943896b761a', 'Brave New World', 'Aldous Huxley', 1932, 'A dystopian vision of a world where humans are controlled through genetic engineering and pleasure.', 9.99),
    ('cd9b7a14-5a5b-4b79-a642-9d4aef872ae0', 'Frankenstein', 'Mary Shelley', 1818, NULL, 7.99),
    ('abdb6ce8-1b2c-43ae-8149-5f7aab66e934', 'Don Quixote', 'Miguel de Cervantes', 1605, 'A comedic adventure of a man who believes himself to be a knight reviving the chivalric tradition.', 12.49),
    ('c35a6ff4-35fb-48e7-9395-82d68e7d51ff', 'The Catcher in the Rye', 'J.D. Salinger', 1951, NULL, 8.49),
    ('e0d09a8f-403f-452e-a291-f7b4b65b7c3a', 'Echoes of the Abyss', 'Rebecca Winters', 2022, 'A thrilling deep-sea expedition that uncovers a lost civilization.', 11.49),
    ('8fd08e41-33b0-403a-bc0f-6cfb9ff6dd55', 'Heart of Darkness', 'Joseph Conrad', 1899, 'A journey into the African Congo that examines the darkness within human nature.', 6.49),
    ('a4fa6d12-7b98-4a4a-b121-9b98a5012f2d', 'Dracula', 'Bram Stoker', 1897, 'A Gothic horror novel about Count Dracula’s attempt to move from Transylvania to England.', 8.99),
    ('fc72801c-540d-4a62-95e4-734aaabc91c4', 'The Odyssey', 'Homer', 1888, 'An ancient Greek epic poem about Odysseus’ long journey home from the Trojan War.', 13.49),
    ('f78de0c6-91cb-41af-92e5-95b4e038d4b6', 'The Road', 'Cormac McCarthy', 2006, 'A father and son’s harrowing journey across a post-apocalyptic landscape.', 10.49),
    ('b49f6f68-7094-4b5e-9ff9-1d4d5d39ed23', 'To Kill a Mockingbird', 'Harper Lee', 1960, 'A novel about racial injustice in the American South as seen through the eyes of a young girl.', 9.99),
    ('db15a215-b84d-4e1b-96bb-bbc7a0d63aa0', 'Slaughterhouse-Five', 'Kurt Vonnegut', 1969, 'A blend of science fiction and anti-war commentary centered on the World War II bombing of Dresden.', 9.49),
    ('c4312a57-8c7e-45d6-a9b2-72f3a88b5c6d', 'The Alchemist', 'Paulo Coelho', 1988, 'A philosophical novel about a young shepherd’s journey to discover his personal legend.', 11.99),
    ('a9137ac1-67d4-4185-b982-845b83265a28', 'One Hundred Years of Solitude', 'Gabriel García Márquez', 1967, 'A magical realist saga of the Buendía family in the fictional town of Macondo.', 13.99),
    ('9b92850e-7b95-44e5-96cb-07ab5bcffcb5', 'Catch-22', 'Joseph Heller', 1961, 'A satirical novel about the absurdities of war, focusing on a bomber squadron in World War II.', 8.99),
    ('c761b3e2-3bc0-45cf-a973-06e9c924ebd4', 'The Stranger', 'Albert Camus', 1942, 'An existential novel about a man who becomes indifferent to society after committing murder.', 7.99),
    ('f6c74688-1674-4db5-9245-abc537b11cf7', 'Fahrenheit 451', 'Ray Bradbury', 1953, 'A dystopian novel set in a future where books are banned and firemen burn them.', 8.99),
    ('d8f8e7b4-5b47-4b3d-81c0-ace19d2fa1b7', 'Beloved', 'Toni Morrison', 1987, 'A haunting novel about slavery and its legacy, told through the story of a woman haunted by the ghost of her dead child.', 9.99),
    ('ba6b5377-66e7-4538-8e96-e5285e151f9d', 'The Hobbit', 'J.R.R. Tolkien', 1937, 'A fantasy novel about Bilbo Baggins’ adventure to win treasure guarded by the dragon Smaug.', 11.99),
    ('aebbf087-cd79-40f6-bf5d-9098d3167fda', 'Crime and Punishment', 'Fyodor Dostoevsky', 1866, 'A psychological novel exploring the moral dilemmas faced by a man who commits murder.', 10.49),
    ('fd9e8c41-3e50-448d-aed0-91e7335f5ad3', 'The Sun Also Rises', 'Ernest Hemingway', 1926, 'A novel about the disillusionment of the post-WWI Lost Generation, set in Europe.', 8.99),
    ('e118f774-7fd4-4d1f-9d45-e55e0f485c0b', 'The Picture of Dorian Gray', 'Oscar Wilde', 1890, 'A novel about a man who remains young while his portrait ages and reflects his moral decay.', 7.49);

INSERT INTO user_books (user_id, book_id)
  VALUES
    ('88eaeab2-b50d-4bc6-87fa-20c6546f4d3d', '8c5b4d76-104a-411b-9abd-a51efa02e0b3'),
    ('88eaeab2-b50d-4bc6-87fa-20c6546f4d3d', '9f1e38e2-5e65-41ab-99f7-6d38299a1dcb'),
    ('c7ac0041-e354-4787-b586-111a350f6229', '9f1e38e2-5e65-41ab-99f7-6d38299a1dcb'),
    ('88eaeab2-b50d-4bc6-87fa-20c6546f4d3d', 'b49f6f68-7094-4b5e-9ff9-1d4d5d39ed23'),
    ('c7ac0041-e354-4787-b586-111a350f6229', 'b67f1f78-dc4f-4638-9363-7155fe087eb0'),
    ('1f1f1cb0-7fe4-4fc9-8722-13dc4763a3f0', 'f4d88c63-17fb-4c0f-8c38-8a8c23c967ba'),
    ('1f1f1cb0-7fe4-4fc9-8722-13dc4763a3f0', 'f845d05c-6ef0-4328-a2ba-4d87442f4ebf'),
    ('5fd785b0-fc58-41de-8a14-804a151dd8b3', 'acd3420d-5f91-4c12-a6de-64a45ae3f2cf'),
    ('5fd785b0-fc58-41de-8a14-804a151dd8b3', 'c761b3e2-3bc0-45cf-a973-06e9c924ebd4'),
    ('fc031fae-0f5f-4715-b8d7-6ab4b5f0f366', 'd13eb543-6eb5-489a-83ae-810f45f4dc47'),
    ('fc031fae-0f5f-4715-b8d7-6ab4b5f0f366', 'e0d09a8f-403f-452e-a291-f7b4b65b7c3a'),
    ('28e03d43-e5c5-48c8-8b83-6569be0fbf3b', '9b92850e-7b95-44e5-96cb-07ab5bcffcb5'),
    ('28e03d43-e5c5-48c8-8b83-6569be0fbf3b', 'fd9e8c41-3e50-448d-aed0-91e7335f5ad3'),
    ('48dff9a9-6404-46ec-9155-6827c10e64eb', 'e118f774-7fd4-4d1f-9d45-e55e0f485c0b'),
    ('48dff9a9-6404-46ec-9155-6827c10e64eb', 'aebbf087-cd79-40f6-bf5d-9098d3167fda'),
    ('51b91ff5-b509-4e79-8764-6ef7a5bcdcc9', 'c35a6ff4-35fb-48e7-9395-82d68e7d51ff'),
    ('51b91ff5-b509-4e79-8764-6ef7a5bcdcc9', 'c4312a57-8c7e-45d6-a9b2-72f3a88b5c6d'),
    ('51b91ff5-b509-4e79-8764-6ef7a5bcdcc9', 'a9137ac1-67d4-4185-b982-845b83265a28'),
    ('51b91ff5-b509-4e79-8764-6ef7a5bcdcc9', 'd8f8e7b4-5b47-4b3d-81c0-ace19d2fa1b7'),
    ('3fca256f-6b10-4be2-96f5-f02aa67c30bc', 'e118f774-7fd4-4d1f-9d45-e55e0f485c0b'),
    ('3fca256f-6b10-4be2-96f5-f02aa67c30bc', 'baf4fc6d-61e7-49e9-8db7-d943896b761a'),
    ('3fca256f-6b10-4be2-96f5-f02aa67c30bc', 'b49f6f68-7094-4b5e-9ff9-1d4d5d39ed23'),
    ('3fca256f-6b10-4be2-96f5-f02aa67c30bc', 'c4312a57-8c7e-45d6-a9b2-72f3a88b5c6d'),
    ('3fca256f-6b10-4be2-96f5-f02aa67c30bc', 'e0d09a8f-403f-452e-a291-f7b4b65b7c3a');