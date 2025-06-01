module mecha::mecha {
    /* ─────────── Imports ────────────────────────────────────────────────── */
    use std::string::{String, utf8};
    use std::vector;

    use sui::object::{UID, new};                      // UID type + new()
    use sui::display::{new_with_fields, update_version};
    use sui::transfer;
    use sui::tx_context;
    use sui::package;

    use mecha::traits::{
        Helmet, Stomach, Body, Wings,
        get_helmet_parts, get_stomach_parts, get_body_parts, get_wings_parts
    };

    /* ─────────── Data structs ───────────────────────────────────────────── */
    public struct Image has store {
        helmet_1: String, helmet_2: String,
        stomach_1: String, stomach_2: String,
        body_1: String, body_2: String, body_3: String, body_4: String,
        wings_1: String, wings_2: String, wings_3: String,
        wings_4: String, wings_5: String, wings_6: String,
    }

    public struct Mecha has key, store {
        id: UID,
        name: String,
        level: u8,
        color: String,
        image: Image,
    }

    /* Capability used once at publish time */
    public struct MECHA has drop {}

    /* ─────────── Package-init ────────────────────── */
    fun init(witness: MECHA, ctx: &mut tx_context::TxContext) {
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

        /* Return capability + Display to the deployer */
        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(disp, tx_context::sender(ctx));
    }

    /* ─────────── Minting ────────────────────────────────────────────────── */
    public fun mint(
        name: String,
        level: u8,
        color: String,
        helmet: &Helmet,
        stomach: &Stomach,
        body: &Body,
        wings: &Wings,
        ctx: &mut tx_context::TxContext,
    ) {
        let (h0, h1)                 = get_helmet_parts(helmet);
        let (s0, s1)                 = get_stomach_parts(stomach);
        let (b0, b1, b2, b3)         = get_body_parts(body);
        let (w0, w1, w2, w3, w4, w5) = get_wings_parts(wings);

        let img = Image {
            helmet_1: h0,  helmet_2: h1,
            stomach_1: s0, stomach_2: s1,
            body_1: b0, body_2: b1, body_3: b2, body_4: b3,
            wings_1: w0, wings_2: w1, wings_3: w2,
            wings_4: w3, wings_5: w4, wings_6: w5,
        };

        let nft = Mecha {
            id: new(ctx),
            name, level, color,
            image: img,
        };

        transfer::transfer(nft, tx_context::sender(ctx));
    }

    /* ─────────── Trait-swap helpers (objects passed in by ref) ──────────── */
    public fun replace_helmet(mecha: &mut Mecha, helmet: &Helmet) {
        let (p0, p1) = get_helmet_parts(helmet);
        mecha.image.helmet_1 = p0;
        mecha.image.helmet_2 = p1;
    }

    public fun replace_stomach(mecha: &mut Mecha, stomach: &Stomach) {
        let (p0, p1) = get_stomach_parts(stomach);
        mecha.image.stomach_1 = p0;
        mecha.image.stomach_2 = p1;
    }

    public fun replace_body(mecha: &mut Mecha, body: &Body) {
        let (p0, p1, p2, p3) = get_body_parts(body);
        mecha.image.body_1 = p0;
        mecha.image.body_2 = p1;
        mecha.image.body_3 = p2;
        mecha.image.body_4 = p3;
    }

    public fun replace_wings(mecha: &mut Mecha, wings: &Wings) {
        let (p0, p1, p2, p3, p4, p5) = get_wings_parts(wings);
        mecha.image.wings_1 = p0;
        mecha.image.wings_2 = p1;
        mecha.image.wings_3 = p2;
        mecha.image.wings_4 = p3;
        mecha.image.wings_5 = p4;
        mecha.image.wings_6 = p5;
    }

}
