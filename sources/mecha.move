module mecha::mecha {
    use std::string::{Self, String, utf8};
    use sui::display::{new_with_fields, update_version};
    use sui::package;
    use mecha::traits::{Trait, get_data};

    /// On-chain Mecha image layout
    public struct Image has store {
        helmet_1: String,
        helmet_2: String,
        stomach_1: String,
        stomach_2: String,
        body_1: String,
        body_2: String,
        body_3: String,
        body_4: String,
        wings_1: String,
        wings_2: String,
        wings_3: String,
        wings_4: String,
        wings_5: String,
        wings_6: String,
    }

    /// The Mecha NFT object
    public struct Mecha has key, store {
        id: UID,
        name: String,
        level: u8,
        color: String,
        image: Image,
    }

    /// Package initialization witness
    public struct MECHA has drop {}

    /// Setup display metadata
    fun init(witness: MECHA, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
            utf8(b"description"),
            utf8(b"level"),
            utf8(b"color"),
        ];

        let values = vector[
            utf8(b"{name}"),
            utf8(b"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='512' height='512'><image href='{image.wings_1}{image.wings_2}{image.wings_3}{image.wings_4}{image.wings_5}{image.wings_6}' x='0' y='0' width='512' height='512'/><image href='{image.stomach_1}{image.stomach_2}' x='0' y='0' width='512' height='512'/><image href='{image.body_1}{image.body_2}{image.body_3}{image.body_4}' x='0' y='0' width='512' height='512'/><image href='{image.helmet_1}{image.helmet_2}' x='0' y='0' width='512' height='512'/></svg>"),
            utf8(b"Level {level} {color} Mecha"),
            utf8(b"{level}"),
            utf8(b"{color}"),
        ];

        let publisher = package::claim(witness, ctx);
        let mut disp = new_with_fields<Mecha>(&publisher, keys, values, ctx);
        update_version(&mut disp);
        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(disp, tx_context::sender(ctx));
    }

    /// Mint a Mecha NFT using all traits (no string concatenation)
    #[allow(lint(self_transfer))]
    public fun mint(
        name: String,
        level: u8,
        color: String,
        helmet: &Trait,
        helmet_extra: &Trait,
        stomach: &Trait,
        stomach_extra: &Trait,
        body1: &Trait,
        body2: &Trait,
        body3: &Trait,
        body4: &Trait,
        wings1: &Trait,
        wings2: &Trait,
        wings3: &Trait,
        wings4: &Trait,
        wings5: &Trait,
        wings6: &Trait,
        ctx: &mut TxContext,
    ) {
        let img = Image {
            helmet_1: get_data(helmet),
            helmet_2: get_data(helmet_extra),
            stomach_1: get_data(stomach),
            stomach_2: get_data(stomach_extra),
            body_1: get_data(body1),
            body_2: get_data(body2),
            body_3: get_data(body3),
            body_4: get_data(body4),
            wings_1: get_data(wings1),
            wings_2: get_data(wings2),
            wings_3: get_data(wings3),
            wings_4: get_data(wings4),
            wings_5: get_data(wings5),
            wings_6: get_data(wings6),
        };

        let nft = Mecha {
            id: sui::object::new(ctx),
            name,
            level,
            color,
            image: img,
        };

        transfer::transfer(nft, tx_context::sender(ctx));
    }

    const E_INVALID_PART: u64 = 100;

    /// Replace a composite trait part in a Mecha NFT
    public fun replace_part(
        mecha: &mut Mecha,
        part: u8,
        new_data: &vector<String>,
    ) {
        if (part == 0) {
            mecha.image.helmet_1 = *vector::borrow(new_data, 0);
            mecha.image.helmet_2 = *vector::borrow(new_data, 1);
        } else if (part == 1) {
            mecha.image.stomach_1 = *vector::borrow(new_data, 0);
            mecha.image.stomach_2 = *vector::borrow(new_data, 1);
        } else if (part == 2) {
            mecha.image.body_1 = *vector::borrow(new_data, 0);
            mecha.image.body_2 = *vector::borrow(new_data, 1);
            mecha.image.body_3 = *vector::borrow(new_data, 2);
            mecha.image.body_4 = *vector::borrow(new_data, 3);
        } else if (part == 3) {
            mecha.image.wings_1 = *vector::borrow(new_data, 0);
            mecha.image.wings_2 = *vector::borrow(new_data, 1);
            mecha.image.wings_3 = *vector::borrow(new_data, 2);
            mecha.image.wings_4 = *vector::borrow(new_data, 3);
            mecha.image.wings_5 = *vector::borrow(new_data, 4);
            mecha.image.wings_6 = *vector::borrow(new_data, 5);
        } else {
            abort E_INVALID_PART;
        }
    }
}
