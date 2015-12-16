import Foundation
import Utils

class Wire : CustomStringConvertible {

    typealias SignalHandler = (signal: UInt16) -> Void

    private var listeners:[SignalHandler] = []

    var signal:UInt16?

    convenience init(_ signal: UInt16) {
        self.init()
        self.signal = signal
    }

    func onSignal(handler: SignalHandler) {
        listeners.append(handler)
        if self.signal != nil {
            handler(signal: self.signal!)
        }
    }

    func connectTo(wire: Wire) {
        onSignal { wire.writeSignal($0) }
    }

    func writeSignal(signal:UInt16) {
        self.signal = signal
        for handler in listeners {
            handler(signal: signal)
        }
    }

    var description:String {
        if signal != nil {
            return "\(signal!)"
        } else {
            return "-"
        }
    }
}

func AndGate(inputA: Wire, _ inputB: Wire) -> Wire {
    let output = Wire()
    inputA.onSignal { (signalA) in
        inputB.onSignal { (signalB) in
            output.writeSignal(signalA & signalB)
        }
    }
    return output
}

func OrGate(inputA: Wire, _ inputB: Wire) -> Wire {
    let output = Wire()
    inputA.onSignal { (signalA) in
        inputB.onSignal { (signalB) in
            output.writeSignal(signalA | signalB)
        }
    }
    return output
}

func LshiftGate(inputA: Wire, _ inputB: Wire) -> Wire {
    let output = Wire()
    inputA.onSignal { (signalA) in
        inputB.onSignal { (signalB) in
            output.writeSignal(signalA << signalB)
        }
    }
    return output
}

func RshiftGate(inputA: Wire, _ inputB: Wire) -> Wire {
    let output = Wire()
    inputA.onSignal { (signalA) in
        inputB.onSignal { (signalB) in
            output.writeSignal(signalA >> signalB)
        }
    }
    return output
}

func NotGate(input: Wire) -> Wire {
    let output = Wire()
    input.onSignal { output.writeSignal(~$0) }
    return output
}

infix operator --> { associativity right }

func --> (left: UInt16, right: Wire) { right.writeSignal(left) }
func --> (left: Wire, inout right: Wire) { left.connectTo(right) }

func & (left: Wire, right: Wire) -> Wire { return AndGate(left, right) }
func & (left: UInt16, right: Wire) -> Wire { return AndGate(Wire(left), right) }

func | (left: Wire, right: Wire) -> Wire { return OrGate(left, right) }
func | (left: UInt16, right: Wire) -> Wire { return OrGate(Wire(left), right) }

func << (left: Wire, right: Wire) -> Wire { return LshiftGate(left, right) }
func << (left: UInt16, right: Wire) -> Wire { return LshiftGate(Wire(left), right) }
func << (left: Wire, right: UInt16) -> Wire { return LshiftGate(left, Wire(right)) }

func >> (left: Wire, right: Wire) -> Wire { return RshiftGate(left, right) }
func >> (left: UInt16, right: Wire) -> Wire { return RshiftGate(Wire(left), right) }
func >> (left: Wire, right: UInt16) -> Wire { return RshiftGate(left, Wire(right)) }

prefix func ~ (input: Wire) -> Wire { return NotGate(input) }
prefix func ~ (input: UInt16) -> Wire { return NotGate(Wire(input)) }


func bobbyTablesToSwift(source: String, prefix: String) -> String {
    var seenWires:Set<String> = []
    var defs = ""
    var src = source
        .stringByReplacingOccurrencesOfString("->", withString: "-->")
        .stringByReplacingOccurrencesOfString("AND", withString: "&")
        .stringByReplacingOccurrencesOfString("OR", withString: "|")
        .stringByReplacingOccurrencesOfString("LSHIFT", withString: "<<")
        .stringByReplacingOccurrencesOfString("RSHIFT", withString: ">>")
        .stringByReplacingOccurrencesOfString("NOT ", withString: "~")

    let regex = try! NSRegularExpression(pattern: "([a-z]+)", options: [])
    let fullRange = NSMakeRange(0, src.characters.count)

    let matches = regex.matchesInString(src, options: [], range: fullRange)
    
    for match in matches {
        let start = src.startIndex.advancedBy(match.range.location)
        let end = start.advancedBy(match.range.length)
        let range = start..<end
        let wireName = src.substringWithRange(range)
        seenWires.insert(wireName)
    }

    for (idx, wire) in seenWires.enumerate() {
        if idx % 3 == 0 { defs += "\n" }
        defs += "var \(prefix)\(wire) = Wire(); "
    }
    
    src = regex.stringByReplacingMatchesInString(
        src, options: [], range: fullRange, withTemplate: "\(prefix)$1"
    )
    
    return defs + "\n" + src
}

//let input = try! loadResourceAsString("input")
//print(bobbyTablesToSwift(input, prefix: "p1_"))
//print(bobbyTablesToSwift(input, prefix: "p2_"))

var p1_er = Wire(); var p1_iq = Wire(); var p1_fd = Wire();
var p1_w = Wire(); var p1_ei = Wire(); var p1_go = Wire();
var p1_iv = Wire(); var p1_df = Wire(); var p1_ap = Wire();
var p1_gr = Wire(); var p1_kw = Wire(); var p1_hb = Wire();
var p1_dq = Wire(); var p1_lc = Wire(); var p1_ct = Wire();
var p1_hf = Wire(); var p1_bn = Wire(); var p1_il = Wire();
var p1_r = Wire(); var p1_c = Wire(); var p1_ff = Wire();
var p1_ao = Wire(); var p1_fv = Wire(); var p1_aq = Wire();
var p1_ad = Wire(); var p1_gg = Wire(); var p1_fh = Wire();
var p1_jv = Wire(); var p1_fs = Wire(); var p1_bh = Wire();
var p1_ih = Wire(); var p1_hs = Wire(); var p1_io = Wire();
var p1_ax = Wire(); var p1_fz = Wire(); var p1_jo = Wire();
var p1_ak = Wire(); var p1_hw = Wire(); var p1_dv = Wire();
var p1_an = Wire(); var p1_gv = Wire(); var p1_dp = Wire();
var p1_hc = Wire(); var p1_v = Wire(); var p1_bd = Wire();
var p1_lp = Wire(); var p1_et = Wire(); var p1_ea = Wire();
var p1_cy = Wire(); var p1_jx = Wire(); var p1_lq = Wire();
var p1_bm = Wire(); var p1_bo = Wire(); var p1_jn = Wire();
var p1_ln = Wire(); var p1_ij = Wire(); var p1_ah = Wire();
var p1_cv = Wire(); var p1_fi = Wire(); var p1_kj = Wire();
var p1_cf = Wire(); var p1_en = Wire(); var p1_dt = Wire();
var p1_f = Wire(); var p1_kz = Wire(); var p1_ai = Wire();
var p1_km = Wire(); var p1_t = Wire(); var p1_in = Wire();
var p1_lk = Wire(); var p1_ja = Wire(); var p1_dn = Wire();
var p1_az = Wire(); var p1_au = Wire(); var p1_fu = Wire();
var p1_iz = Wire(); var p1_fy = Wire(); var p1_bl = Wire();
var p1_kq = Wire(); var p1_ma = Wire(); var p1_jc = Wire();
var p1_ch = Wire(); var p1_de = Wire(); var p1_ko = Wire();
var p1_fe = Wire(); var p1_ky = Wire(); var p1_bk = Wire();
var p1_fg = Wire(); var p1_jj = Wire(); var p1_lm = Wire();
var p1_fq = Wire(); var p1_bb = Wire(); var p1_e = Wire();
var p1_di = Wire(); var p1_ev = Wire(); var p1_dg = Wire();
var p1_j = Wire(); var p1_dy = Wire(); var p1_jl = Wire();
var p1_el = Wire(); var p1_li = Wire(); var p1_lu = Wire();
var p1_fl = Wire(); var p1_dr = Wire(); var p1_dd = Wire();
var p1_ed = Wire(); var p1_z = Wire(); var p1_gf = Wire();
var p1_it = Wire(); var p1_jq = Wire(); var p1_kc = Wire();
var p1_lr = Wire(); var p1_hr = Wire(); var p1_ls = Wire();
var p1_l = Wire(); var p1_al = Wire(); var p1_lj = Wire();
var p1_gt = Wire(); var p1_kt = Wire(); var p1_fj = Wire();
var p1_n = Wire(); var p1_jm = Wire(); var p1_cs = Wire();
var p1_ho = Wire(); var p1_gm = Wire(); var p1_ab = Wire();
var p1_gi = Wire(); var p1_am = Wire(); var p1_dk = Wire();
var p1_jh = Wire(); var p1_br = Wire(); var p1_kd = Wire();
var p1_lb = Wire(); var p1_hz = Wire(); var p1_kg = Wire();
var p1_ku = Wire(); var p1_eg = Wire(); var p1_dm = Wire();
var p1_lw = Wire(); var p1_y = Wire(); var p1_hy = Wire();
var p1_bt = Wire(); var p1_ka = Wire(); var p1_cl = Wire();
var p1_ks = Wire(); var p1_ex = Wire(); var p1_by = Wire();
var p1_fp = Wire(); var p1_bp = Wire(); var p1_d = Wire();
var p1_hx = Wire(); var p1_k = Wire(); var p1_ek = Wire();
var p1_ft = Wire(); var p1_ba = Wire(); var p1_ii = Wire();
var p1_gh = Wire(); var p1_m = Wire(); var p1_hl = Wire();
var p1_iw = Wire(); var p1_hi = Wire(); var p1_jz = Wire();
var p1_ez = Wire(); var p1_kv = Wire(); var p1_fr = Wire();
var p1_aa = Wire(); var p1_lx = Wire(); var p1_iy = Wire();
var p1_cr = Wire(); var p1_jg = Wire(); var p1_ie = Wire();
var p1_fa = Wire(); var p1_gp = Wire(); var p1_ce = Wire();
var p1_aw = Wire(); var p1_cx = Wire(); var p1_fc = Wire();
var p1_fo = Wire(); var p1_jy = Wire(); var p1_he = Wire();
var p1_jb = Wire(); var p1_ig = Wire(); var p1_fw = Wire();
var p1_db = Wire(); var p1_dw = Wire(); var p1_la = Wire();
var p1_id = Wire(); var p1_ae = Wire(); var p1_cu = Wire();
var p1_hh = Wire(); var p1_da = Wire(); var p1_eq = Wire();
var p1_lo = Wire(); var p1_p = Wire(); var p1_jt = Wire();
var p1_gs = Wire(); var p1_gz = Wire(); var p1_jr = Wire();
var p1_kl = Wire(); var p1_ep = Wire(); var p1_bg = Wire();
var p1_gd = Wire(); var p1_lh = Wire(); var p1_ha = Wire();
var p1_gw = Wire(); var p1_ly = Wire(); var p1_jd = Wire();
var p1_je = Wire(); var p1_hd = Wire(); var p1_cm = Wire();
var p1_q = Wire(); var p1_kf = Wire(); var p1_b = Wire();
var p1_ic = Wire(); var p1_kx = Wire(); var p1_ik = Wire();
var p1_kb = Wire(); var p1_gb = Wire(); var p1_cw = Wire();
var p1_cc = Wire(); var p1_bs = Wire(); var p1_ia = Wire();
var p1_is = Wire(); var p1_ej = Wire(); var p1_kr = Wire();
var p1_at = Wire(); var p1_eo = Wire(); var p1_ey = Wire();
var p1_fk = Wire(); var p1_iu = Wire(); var p1_bi = Wire();
var p1_es = Wire(); var p1_bj = Wire(); var p1_ci = Wire();
var p1_em = Wire(); var p1_kp = Wire(); var p1_kh = Wire();
var p1_cj = Wire(); var p1_ke = Wire(); var p1_av = Wire();
var p1_ix = Wire(); var p1_dc = Wire(); var p1_hn = Wire();
var p1_kn = Wire(); var p1_ee = Wire(); var p1_cz = Wire();
var p1_dl = Wire(); var p1_a = Wire(); var p1_fb = Wire();
var p1_gn = Wire(); var p1_g = Wire(); var p1_kk = Wire();
var p1_bv = Wire(); var p1_bu = Wire(); var p1_cq = Wire();
var p1_ip = Wire(); var p1_lg = Wire(); var p1_gy = Wire();
var p1_x = Wire(); var p1_ju = Wire(); var p1_lt = Wire();
var p1_hv = Wire(); var p1_do = Wire(); var p1_gx = Wire();
var p1_be = Wire(); var p1_bq = Wire(); var p1_eu = Wire();
var p1_hj = Wire(); var p1_ki = Wire(); var p1_aj = Wire();
var p1_cd = Wire(); var p1_gc = Wire(); var p1_ld = Wire();
var p1_gu = Wire(); var p1_ds = Wire(); var p1_ji = Wire();
var p1_du = Wire(); var p1_gl = Wire(); var p1_ll = Wire();
var p1_ec = Wire(); var p1_lz = Wire(); var p1_fn = Wire();
var p1_hp = Wire(); var p1_gk = Wire(); var p1_o = Wire();
var p1_cn = Wire(); var p1_i = Wire(); var p1_dx = Wire();
var p1_lf = Wire(); var p1_as = Wire(); var p1_fx = Wire();
var p1_lv = Wire(); var p1_hk = Wire(); var p1_ge = Wire();
var p1_bz = Wire(); var p1_ht = Wire(); var p1_jf = Wire();
var p1_hm = Wire(); var p1_ef = Wire(); var p1_ag = Wire();
var p1_bx = Wire(); var p1_u = Wire(); var p1_ca = Wire();
var p1_bf = Wire(); var p1_gj = Wire(); var p1_ir = Wire();
var p1_le = Wire(); var p1_af = Wire(); var p1_hu = Wire();
var p1_cp = Wire(); var p1_eh = Wire(); var p1_ib = Wire();
var p1_if = Wire(); var p1_co = Wire(); var p1_bc = Wire();
var p1_js = Wire(); var p1_ga = Wire(); var p1_bw = Wire();
var p1_jk = Wire(); var p1_h = Wire(); var p1_jw = Wire();
var p1_jp = Wire(); var p1_ay = Wire(); var p1_cg = Wire();
var p1_fm = Wire(); var p1_dz = Wire(); var p1_cb = Wire();
var p1_hq = Wire(); var p1_ac = Wire(); var p1_im = Wire();
var p1_dj = Wire(); var p1_ew = Wire(); var p1_ar = Wire();
var p1_s = Wire(); var p1_eb = Wire(); var p1_gq = Wire();
var p1_hg = Wire(); var p1_ck = Wire(); var p1_dh = Wire();
p1_af & p1_ah --> p1_ai
~p1_lk --> p1_ll
p1_hz >> 1 --> p1_is
~p1_go --> p1_gp
p1_du | p1_dt --> p1_dv
p1_x >> 5 --> p1_aa
p1_at | p1_az --> p1_ba
p1_eo << 15 --> p1_es
p1_ci | p1_ct --> p1_cu
p1_b >> 5 --> p1_f
p1_fm | p1_fn --> p1_fo
~p1_ag --> p1_ah
p1_v | p1_w --> p1_x
p1_g & p1_i --> p1_j
p1_an << 15 --> p1_ar
1 & p1_cx --> p1_cy
p1_jq & p1_jw --> p1_jy
p1_iu >> 5 --> p1_ix
p1_gl & p1_gm --> p1_go
~p1_bw --> p1_bx
p1_jp >> 3 --> p1_jr
p1_hg & p1_hh --> p1_hj
p1_bv & p1_bx --> p1_by
p1_er | p1_es --> p1_et
p1_kl | p1_kr --> p1_ks
p1_et >> 1 --> p1_fm
p1_e & p1_f --> p1_h
p1_u << 1 --> p1_ao
p1_he >> 1 --> p1_hx
p1_eg & p1_ei --> p1_ej
p1_bo & p1_bu --> p1_bw
p1_dz | p1_ef --> p1_eg
p1_dy >> 3 --> p1_ea
p1_gl | p1_gm --> p1_gn
p1_da << 1 --> p1_du
p1_au | p1_av --> p1_aw
p1_gj | p1_gu --> p1_gv
p1_eu | p1_fa --> p1_fb
p1_lg | p1_lm --> p1_ln
p1_e | p1_f --> p1_g
~p1_dm --> p1_dn
~p1_l --> p1_m
p1_aq | p1_ar --> p1_as
p1_gj >> 5 --> p1_gm
p1_hm & p1_ho --> p1_hp
p1_ge << 15 --> p1_gi
p1_jp >> 1 --> p1_ki
p1_hg | p1_hh --> p1_hi
p1_lc << 1 --> p1_lw
p1_km | p1_kn --> p1_ko
p1_eq << 1 --> p1_fk
1 & p1_am --> p1_an
p1_gj >> 1 --> p1_hc
p1_aj & p1_al --> p1_am
p1_gj & p1_gu --> p1_gw
p1_ko & p1_kq --> p1_kr
p1_ha | p1_gz --> p1_hb
p1_bn | p1_by --> p1_bz
p1_iv | p1_jb --> p1_jc
~p1_ac --> p1_ad
p1_bo | p1_bu --> p1_bv
p1_d & p1_j --> p1_l
p1_bk << 1 --> p1_ce
p1_de | p1_dk --> p1_dl
p1_dd >> 1 --> p1_dw
p1_hz & p1_ik --> p1_im
~p1_jd --> p1_je
p1_fo >> 2 --> p1_fp
p1_hb << 1 --> p1_hv
p1_lf >> 2 --> p1_lg
p1_gj >> 3 --> p1_gl
p1_ki | p1_kj --> p1_kk
~p1_ak --> p1_al
p1_ld | p1_le --> p1_lf
p1_ci >> 3 --> p1_ck
1 & p1_cc --> p1_cd
~p1_kx --> p1_ky
p1_fp | p1_fv --> p1_fw
p1_ev & p1_ew --> p1_ey
p1_dt << 15 --> p1_dx
~p1_ax --> p1_ay
p1_bp & p1_bq --> p1_bs
~p1_ii --> p1_ij
p1_ci & p1_ct --> p1_cv
p1_iq | p1_ip --> p1_ir
p1_x >> 2 --> p1_y
p1_fq | p1_fr --> p1_fs
p1_bn >> 5 --> p1_bq
0 --> p1_c
14146 --> p1_b
p1_d | p1_j --> p1_k
p1_z | p1_aa --> p1_ab
p1_gf | p1_ge --> p1_gg
p1_df | p1_dg --> p1_dh
~p1_hj --> p1_hk
~p1_di --> p1_dj
p1_fj << 15 --> p1_fn
p1_lf >> 1 --> p1_ly
p1_b & p1_n --> p1_p
p1_jq | p1_jw --> p1_jx
p1_gn & p1_gp --> p1_gq
p1_x >> 1 --> p1_aq
p1_ex & p1_ez --> p1_fa
~p1_fc --> p1_fd
p1_bj | p1_bi --> p1_bk
p1_as >> 5 --> p1_av
p1_hu << 15 --> p1_hy
~p1_gs --> p1_gt
p1_fs & p1_fu --> p1_fv
p1_dh & p1_dj --> p1_dk
p1_bz & p1_cb --> p1_cc
p1_dy >> 1 --> p1_er
p1_hc | p1_hd --> p1_he
p1_fo | p1_fz --> p1_ga
p1_t | p1_s --> p1_u
p1_b >> 2 --> p1_d
~p1_jy --> p1_jz
p1_hz >> 2 --> p1_ia
p1_kk & p1_kv --> p1_kx
p1_ga & p1_gc --> p1_gd
p1_fl << 1 --> p1_gf
p1_bn & p1_by --> p1_ca
~p1_hr --> p1_hs
~p1_bs --> p1_bt
p1_lf >> 3 --> p1_lh
p1_au & p1_av --> p1_ax
1 & p1_gd --> p1_ge
p1_jr | p1_js --> p1_jt
p1_fw & p1_fy --> p1_fz
~p1_iz --> p1_ja
p1_c << 1 --> p1_t
p1_dy >> 5 --> p1_eb
p1_bp | p1_bq --> p1_br
~p1_h --> p1_i
1 & p1_ds --> p1_dt
p1_ab & p1_ad --> p1_ae
p1_ap << 1 --> p1_bj
p1_br & p1_bt --> p1_bu
~p1_ca --> p1_cb
~p1_el --> p1_em
p1_s << 15 --> p1_w
p1_gk | p1_gq --> p1_gr
p1_ff & p1_fh --> p1_fi
p1_kf << 15 --> p1_kj
p1_fp & p1_fv --> p1_fx
p1_lh | p1_li --> p1_lj
p1_bn >> 3 --> p1_bp
p1_jp | p1_ka --> p1_kb
p1_lw | p1_lv --> p1_lx
p1_iy & p1_ja --> p1_jb
p1_dy | p1_ej --> p1_ek
1 & p1_bh --> p1_bi
~p1_kt --> p1_ku
p1_ao | p1_an --> p1_ap
p1_ia & p1_ig --> p1_ii
~p1_ey --> p1_ez
p1_bn >> 1 --> p1_cg
p1_fk | p1_fj --> p1_fl
p1_ce | p1_cd --> p1_cf
p1_eu & p1_fa --> p1_fc
p1_kg | p1_kf --> p1_kh
p1_jr & p1_js --> p1_ju
p1_iu >> 3 --> p1_iw
p1_df & p1_dg --> p1_di
p1_dl & p1_dn --> p1_do
p1_la << 15 --> p1_le
p1_fo >> 1 --> p1_gh
~p1_gw --> p1_gx
~p1_gb --> p1_gc
p1_ir << 1 --> p1_jl
p1_x & p1_ai --> p1_ak
p1_he >> 5 --> p1_hh
1 & p1_lu --> p1_lv
~p1_ft --> p1_fu
p1_gh | p1_gi --> p1_gj
p1_lf >> 5 --> p1_li
p1_x >> 3 --> p1_z
p1_b >> 3 --> p1_e
p1_he >> 2 --> p1_hf
~p1_fx --> p1_fy
p1_jt & p1_jv --> p1_jw
p1_hx | p1_hy --> p1_hz
p1_jp & p1_ka --> p1_kc
p1_fb & p1_fd --> p1_fe
p1_hz | p1_ik --> p1_il
p1_ci >> 1 --> p1_db
p1_fo & p1_fz --> p1_gb
p1_fq & p1_fr --> p1_ft
p1_gj >> 2 --> p1_gk
p1_cg | p1_ch --> p1_ci
p1_cd << 15 --> p1_ch
p1_jm << 1 --> p1_kg
p1_ih & p1_ij --> p1_ik
p1_fo >> 3 --> p1_fq
p1_fo >> 5 --> p1_fr
1 & p1_fi --> p1_fj
1 & p1_kz --> p1_la
p1_iu & p1_jf --> p1_jh
p1_cq & p1_cs --> p1_ct
p1_dv << 1 --> p1_ep
p1_hf | p1_hl --> p1_hm
p1_km & p1_kn --> p1_kp
p1_de & p1_dk --> p1_dm
p1_dd >> 5 --> p1_dg
~p1_lo --> p1_lp
~p1_ju --> p1_jv
~p1_fg --> p1_fh
p1_cm & p1_co --> p1_cp
p1_ea & p1_eb --> p1_ed
p1_dd >> 3 --> p1_df
p1_gr & p1_gt --> p1_gu
p1_ep | p1_eo --> p1_eq
p1_cj & p1_cp --> p1_cr
p1_lf | p1_lq --> p1_lr
p1_gg << 1 --> p1_ha
p1_et >> 2 --> p1_eu
~p1_jh --> p1_ji
p1_ek & p1_em --> p1_en
p1_jk << 15 --> p1_jo
p1_ia | p1_ig --> p1_ih
p1_gv & p1_gx --> p1_gy
p1_et & p1_fe --> p1_fg
p1_lh & p1_li --> p1_lk
1 & p1_io --> p1_ip
p1_kb & p1_kd --> p1_ke
p1_kk >> 5 --> p1_kn
p1_id & p1_if --> p1_ig
~p1_ls --> p1_lt
p1_dw | p1_dx --> p1_dy
p1_dd & p1_do --> p1_dq
p1_lf & p1_lq --> p1_ls
~p1_kc --> p1_kd
p1_dy & p1_ej --> p1_el
1 & p1_ke --> p1_kf
p1_et | p1_fe --> p1_ff
p1_hz >> 5 --> p1_ic
p1_dd | p1_do --> p1_dp
p1_cj | p1_cp --> p1_cq
~p1_dq --> p1_dr
p1_kk >> 1 --> p1_ld
p1_jg & p1_ji --> p1_jj
p1_he | p1_hp --> p1_hq
p1_hi & p1_hk --> p1_hl
p1_dp & p1_dr --> p1_ds
p1_dz & p1_ef --> p1_eh
p1_hz >> 3 --> p1_ib
p1_db | p1_dc --> p1_dd
p1_hw << 1 --> p1_iq
p1_he & p1_hp --> p1_hr
~p1_cr --> p1_cs
p1_lg & p1_lm --> p1_lo
p1_hv | p1_hu --> p1_hw
p1_il & p1_in --> p1_io
~p1_eh --> p1_ei
p1_gz << 15 --> p1_hd
p1_gk & p1_gq --> p1_gs
1 & p1_en --> p1_eo
~p1_kp --> p1_kq
p1_et >> 5 --> p1_ew
p1_lj & p1_ll --> p1_lm
p1_he >> 3 --> p1_hg
p1_et >> 3 --> p1_ev
p1_as & p1_bd --> p1_bf
p1_cu & p1_cw --> p1_cx
p1_jx & p1_jz --> p1_ka
p1_b | p1_n --> p1_o
p1_be & p1_bg --> p1_bh
1 & p1_ht --> p1_hu
1 & p1_gy --> p1_gz
~p1_hn --> p1_ho
p1_ck | p1_cl --> p1_cm
p1_ec & p1_ee --> p1_ef
p1_lv << 15 --> p1_lz
p1_ks & p1_ku --> p1_kv
~p1_ie --> p1_if
p1_hf & p1_hl --> p1_hn
1 & p1_r --> p1_s
p1_ib & p1_ic --> p1_ie
p1_hq & p1_hs --> p1_ht
p1_y & p1_ae --> p1_ag
~p1_ed --> p1_ee
p1_bi << 15 --> p1_bm
p1_dy >> 2 --> p1_dz
p1_ci >> 2 --> p1_cj
~p1_bf --> p1_bg
~p1_im --> p1_in
p1_ev | p1_ew --> p1_ex
p1_ib | p1_ic --> p1_id
p1_bn >> 2 --> p1_bo
p1_dd >> 2 --> p1_de
p1_bl | p1_bm --> p1_bn
p1_as >> 1 --> p1_bl
p1_ea | p1_eb --> p1_ec
p1_ln & p1_lp --> p1_lq
p1_kk >> 3 --> p1_km
p1_is | p1_it --> p1_iu
p1_iu >> 2 --> p1_iv
p1_as | p1_bd --> p1_be
p1_ip << 15 --> p1_it
p1_iw | p1_ix --> p1_iy
p1_kk >> 2 --> p1_kl
~p1_bb --> p1_bc
p1_ci >> 5 --> p1_cl
p1_ly | p1_lz --> p1_ma
p1_z & p1_aa --> p1_ac
p1_iu >> 1 --> p1_jn
p1_cy << 15 --> p1_dc
p1_cf << 1 --> p1_cz
p1_as >> 3 --> p1_au
p1_cz | p1_cy --> p1_da
p1_kw & p1_ky --> p1_kz
p1_lx --> p1_a
p1_iw & p1_ix --> p1_iz
p1_lr & p1_lt --> p1_lu
p1_jp >> 5 --> p1_js
p1_aw & p1_ay --> p1_az
p1_jc & p1_je --> p1_jf
p1_lb | p1_la --> p1_lc
~p1_cn --> p1_co
p1_kh << 1 --> p1_lb
1 & p1_jj --> p1_jk
p1_y | p1_ae --> p1_af
p1_ck & p1_cl --> p1_cn
p1_kk | p1_kv --> p1_kw
~p1_cv --> p1_cw
p1_kl & p1_kr --> p1_kt
p1_iu | p1_jf --> p1_jg
p1_at & p1_az --> p1_bb
p1_jp >> 2 --> p1_jq
p1_iv & p1_jb --> p1_jd
p1_jn | p1_jo --> p1_jp
p1_x | p1_ai --> p1_aj
p1_ba & p1_bc --> p1_bd
p1_jl | p1_jk --> p1_jm
p1_b >> 1 --> p1_v
p1_o & p1_q --> p1_r
~p1_p --> p1_q
p1_k & p1_m --> p1_n
p1_as >> 2 --> p1_at

var p2_er = Wire(); var p2_iq = Wire(); var p2_fd = Wire();
var p2_w = Wire(); var p2_ei = Wire(); var p2_go = Wire();
var p2_iv = Wire(); var p2_df = Wire(); var p2_ap = Wire();
var p2_gr = Wire(); var p2_kw = Wire(); var p2_hb = Wire();
var p2_dq = Wire(); var p2_lc = Wire(); var p2_ct = Wire();
var p2_hf = Wire(); var p2_bn = Wire(); var p2_il = Wire();
var p2_r = Wire(); var p2_c = Wire(); var p2_ff = Wire();
var p2_ao = Wire(); var p2_fv = Wire(); var p2_aq = Wire();
var p2_ad = Wire(); var p2_gg = Wire(); var p2_fh = Wire();
var p2_jv = Wire(); var p2_fs = Wire(); var p2_bh = Wire();
var p2_ih = Wire(); var p2_hs = Wire(); var p2_io = Wire();
var p2_ax = Wire(); var p2_fz = Wire(); var p2_jo = Wire();
var p2_ak = Wire(); var p2_hw = Wire(); var p2_dv = Wire();
var p2_an = Wire(); var p2_gv = Wire(); var p2_dp = Wire();
var p2_hc = Wire(); var p2_v = Wire(); var p2_bd = Wire();
var p2_lp = Wire(); var p2_et = Wire(); var p2_ea = Wire();
var p2_cy = Wire(); var p2_jx = Wire(); var p2_lq = Wire();
var p2_bm = Wire(); var p2_bo = Wire(); var p2_jn = Wire();
var p2_ln = Wire(); var p2_ij = Wire(); var p2_ah = Wire();
var p2_cv = Wire(); var p2_fi = Wire(); var p2_kj = Wire();
var p2_cf = Wire(); var p2_en = Wire(); var p2_dt = Wire();
var p2_f = Wire(); var p2_kz = Wire(); var p2_ai = Wire();
var p2_km = Wire(); var p2_t = Wire(); var p2_in = Wire();
var p2_lk = Wire(); var p2_ja = Wire(); var p2_dn = Wire();
var p2_az = Wire(); var p2_au = Wire(); var p2_fu = Wire();
var p2_iz = Wire(); var p2_fy = Wire(); var p2_bl = Wire();
var p2_kq = Wire(); var p2_ma = Wire(); var p2_jc = Wire();
var p2_ch = Wire(); var p2_de = Wire(); var p2_ko = Wire();
var p2_fe = Wire(); var p2_ky = Wire(); var p2_bk = Wire();
var p2_fg = Wire(); var p2_jj = Wire(); var p2_lm = Wire();
var p2_fq = Wire(); var p2_bb = Wire(); var p2_e = Wire();
var p2_di = Wire(); var p2_ev = Wire(); var p2_dg = Wire();
var p2_j = Wire(); var p2_dy = Wire(); var p2_jl = Wire();
var p2_el = Wire(); var p2_li = Wire(); var p2_lu = Wire();
var p2_fl = Wire(); var p2_dr = Wire(); var p2_dd = Wire();
var p2_ed = Wire(); var p2_z = Wire(); var p2_gf = Wire();
var p2_it = Wire(); var p2_jq = Wire(); var p2_kc = Wire();
var p2_lr = Wire(); var p2_hr = Wire(); var p2_ls = Wire();
var p2_l = Wire(); var p2_al = Wire(); var p2_lj = Wire();
var p2_gt = Wire(); var p2_kt = Wire(); var p2_fj = Wire();
var p2_n = Wire(); var p2_jm = Wire(); var p2_cs = Wire();
var p2_ho = Wire(); var p2_gm = Wire(); var p2_ab = Wire();
var p2_gi = Wire(); var p2_am = Wire(); var p2_dk = Wire();
var p2_jh = Wire(); var p2_br = Wire(); var p2_kd = Wire();
var p2_lb = Wire(); var p2_hz = Wire(); var p2_kg = Wire();
var p2_ku = Wire(); var p2_eg = Wire(); var p2_dm = Wire();
var p2_lw = Wire(); var p2_y = Wire(); var p2_hy = Wire();
var p2_bt = Wire(); var p2_ka = Wire(); var p2_cl = Wire();
var p2_ks = Wire(); var p2_ex = Wire(); var p2_by = Wire();
var p2_fp = Wire(); var p2_bp = Wire(); var p2_d = Wire();
var p2_hx = Wire(); var p2_k = Wire(); var p2_ek = Wire();
var p2_ft = Wire(); var p2_ba = Wire(); var p2_ii = Wire();
var p2_gh = Wire(); var p2_m = Wire(); var p2_hl = Wire();
var p2_iw = Wire(); var p2_hi = Wire(); var p2_jz = Wire();
var p2_ez = Wire(); var p2_kv = Wire(); var p2_fr = Wire();
var p2_aa = Wire(); var p2_lx = Wire(); var p2_iy = Wire();
var p2_cr = Wire(); var p2_jg = Wire(); var p2_ie = Wire();
var p2_fa = Wire(); var p2_gp = Wire(); var p2_ce = Wire();
var p2_aw = Wire(); var p2_cx = Wire(); var p2_fc = Wire();
var p2_fo = Wire(); var p2_jy = Wire(); var p2_he = Wire();
var p2_jb = Wire(); var p2_ig = Wire(); var p2_fw = Wire();
var p2_db = Wire(); var p2_dw = Wire(); var p2_la = Wire();
var p2_id = Wire(); var p2_ae = Wire(); var p2_cu = Wire();
var p2_hh = Wire(); var p2_da = Wire(); var p2_eq = Wire();
var p2_lo = Wire(); var p2_p = Wire(); var p2_jt = Wire();
var p2_gs = Wire(); var p2_gz = Wire(); var p2_jr = Wire();
var p2_kl = Wire(); var p2_ep = Wire(); var p2_bg = Wire();
var p2_gd = Wire(); var p2_lh = Wire(); var p2_ha = Wire();
var p2_gw = Wire(); var p2_ly = Wire(); var p2_jd = Wire();
var p2_je = Wire(); var p2_hd = Wire(); var p2_cm = Wire();
var p2_q = Wire(); var p2_kf = Wire(); var p2_b = Wire();
var p2_ic = Wire(); var p2_kx = Wire(); var p2_ik = Wire();
var p2_kb = Wire(); var p2_gb = Wire(); var p2_cw = Wire();
var p2_cc = Wire(); var p2_bs = Wire(); var p2_ia = Wire();
var p2_is = Wire(); var p2_ej = Wire(); var p2_kr = Wire();
var p2_at = Wire(); var p2_eo = Wire(); var p2_ey = Wire();
var p2_fk = Wire(); var p2_iu = Wire(); var p2_bi = Wire();
var p2_es = Wire(); var p2_bj = Wire(); var p2_ci = Wire();
var p2_em = Wire(); var p2_kp = Wire(); var p2_kh = Wire();
var p2_cj = Wire(); var p2_ke = Wire(); var p2_av = Wire();
var p2_ix = Wire(); var p2_dc = Wire(); var p2_hn = Wire();
var p2_kn = Wire(); var p2_ee = Wire(); var p2_cz = Wire();
var p2_dl = Wire(); var p2_a = Wire(); var p2_fb = Wire();
var p2_gn = Wire(); var p2_g = Wire(); var p2_kk = Wire();
var p2_bv = Wire(); var p2_bu = Wire(); var p2_cq = Wire();
var p2_ip = Wire(); var p2_lg = Wire(); var p2_gy = Wire();
var p2_x = Wire(); var p2_ju = Wire(); var p2_lt = Wire();
var p2_hv = Wire(); var p2_do = Wire(); var p2_gx = Wire();
var p2_be = Wire(); var p2_bq = Wire(); var p2_eu = Wire();
var p2_hj = Wire(); var p2_ki = Wire(); var p2_aj = Wire();
var p2_cd = Wire(); var p2_gc = Wire(); var p2_ld = Wire();
var p2_gu = Wire(); var p2_ds = Wire(); var p2_ji = Wire();
var p2_du = Wire(); var p2_gl = Wire(); var p2_ll = Wire();
var p2_ec = Wire(); var p2_lz = Wire(); var p2_fn = Wire();
var p2_hp = Wire(); var p2_gk = Wire(); var p2_o = Wire();
var p2_cn = Wire(); var p2_i = Wire(); var p2_dx = Wire();
var p2_lf = Wire(); var p2_as = Wire(); var p2_fx = Wire();
var p2_lv = Wire(); var p2_hk = Wire(); var p2_ge = Wire();
var p2_bz = Wire(); var p2_ht = Wire(); var p2_jf = Wire();
var p2_hm = Wire(); var p2_ef = Wire(); var p2_ag = Wire();
var p2_bx = Wire(); var p2_u = Wire(); var p2_ca = Wire();
var p2_bf = Wire(); var p2_gj = Wire(); var p2_ir = Wire();
var p2_le = Wire(); var p2_af = Wire(); var p2_hu = Wire();
var p2_cp = Wire(); var p2_eh = Wire(); var p2_ib = Wire();
var p2_if = Wire(); var p2_co = Wire(); var p2_bc = Wire();
var p2_js = Wire(); var p2_ga = Wire(); var p2_bw = Wire();
var p2_jk = Wire(); var p2_h = Wire(); var p2_jw = Wire();
var p2_jp = Wire(); var p2_ay = Wire(); var p2_cg = Wire();
var p2_fm = Wire(); var p2_dz = Wire(); var p2_cb = Wire();
var p2_hq = Wire(); var p2_ac = Wire(); var p2_im = Wire();
var p2_dj = Wire(); var p2_ew = Wire(); var p2_ar = Wire();
var p2_s = Wire(); var p2_eb = Wire(); var p2_gq = Wire();
var p2_hg = Wire(); var p2_ck = Wire(); var p2_dh = Wire();


p1_a.onSignal {
    print("Part 1: a signal is \($0)")
    p2_b.writeSignal($0)
}

p2_a.onSignal {
    print("Part 2: a signal is \($0)")
}

p2_af & p2_ah --> p2_ai
~p2_lk --> p2_ll
p2_hz >> 1 --> p2_is
~p2_go --> p2_gp
p2_du | p2_dt --> p2_dv
p2_x >> 5 --> p2_aa
p2_at | p2_az --> p2_ba
p2_eo << 15 --> p2_es
p2_ci | p2_ct --> p2_cu
p2_b >> 5 --> p2_f
p2_fm | p2_fn --> p2_fo
~p2_ag --> p2_ah
p2_v | p2_w --> p2_x
p2_g & p2_i --> p2_j
p2_an << 15 --> p2_ar
1 & p2_cx --> p2_cy
p2_jq & p2_jw --> p2_jy
p2_iu >> 5 --> p2_ix
p2_gl & p2_gm --> p2_go
~p2_bw --> p2_bx
p2_jp >> 3 --> p2_jr
p2_hg & p2_hh --> p2_hj
p2_bv & p2_bx --> p2_by
p2_er | p2_es --> p2_et
p2_kl | p2_kr --> p2_ks
p2_et >> 1 --> p2_fm
p2_e & p2_f --> p2_h
p2_u << 1 --> p2_ao
p2_he >> 1 --> p2_hx
p2_eg & p2_ei --> p2_ej
p2_bo & p2_bu --> p2_bw
p2_dz | p2_ef --> p2_eg
p2_dy >> 3 --> p2_ea
p2_gl | p2_gm --> p2_gn
p2_da << 1 --> p2_du
p2_au | p2_av --> p2_aw
p2_gj | p2_gu --> p2_gv
p2_eu | p2_fa --> p2_fb
p2_lg | p2_lm --> p2_ln
p2_e | p2_f --> p2_g
~p2_dm --> p2_dn
~p2_l --> p2_m
p2_aq | p2_ar --> p2_as
p2_gj >> 5 --> p2_gm
p2_hm & p2_ho --> p2_hp
p2_ge << 15 --> p2_gi
p2_jp >> 1 --> p2_ki
p2_hg | p2_hh --> p2_hi
p2_lc << 1 --> p2_lw
p2_km | p2_kn --> p2_ko
p2_eq << 1 --> p2_fk
1 & p2_am --> p2_an
p2_gj >> 1 --> p2_hc
p2_aj & p2_al --> p2_am
p2_gj & p2_gu --> p2_gw
p2_ko & p2_kq --> p2_kr
p2_ha | p2_gz --> p2_hb
p2_bn | p2_by --> p2_bz
p2_iv | p2_jb --> p2_jc
~p2_ac --> p2_ad
p2_bo | p2_bu --> p2_bv
p2_d & p2_j --> p2_l
p2_bk << 1 --> p2_ce
p2_de | p2_dk --> p2_dl
p2_dd >> 1 --> p2_dw
p2_hz & p2_ik --> p2_im
~p2_jd --> p2_je
p2_fo >> 2 --> p2_fp
p2_hb << 1 --> p2_hv
p2_lf >> 2 --> p2_lg
p2_gj >> 3 --> p2_gl
p2_ki | p2_kj --> p2_kk
~p2_ak --> p2_al
p2_ld | p2_le --> p2_lf
p2_ci >> 3 --> p2_ck
1 & p2_cc --> p2_cd
~p2_kx --> p2_ky
p2_fp | p2_fv --> p2_fw
p2_ev & p2_ew --> p2_ey
p2_dt << 15 --> p2_dx
~p2_ax --> p2_ay
p2_bp & p2_bq --> p2_bs
~p2_ii --> p2_ij
p2_ci & p2_ct --> p2_cv
p2_iq | p2_ip --> p2_ir
p2_x >> 2 --> p2_y
p2_fq | p2_fr --> p2_fs
p2_bn >> 5 --> p2_bq
0 --> p2_c
//14146 --> p2_b
p2_d | p2_j --> p2_k
p2_z | p2_aa --> p2_ab
p2_gf | p2_ge --> p2_gg
p2_df | p2_dg --> p2_dh
~p2_hj --> p2_hk
~p2_di --> p2_dj
p2_fj << 15 --> p2_fn
p2_lf >> 1 --> p2_ly
p2_b & p2_n --> p2_p
p2_jq | p2_jw --> p2_jx
p2_gn & p2_gp --> p2_gq
p2_x >> 1 --> p2_aq
p2_ex & p2_ez --> p2_fa
~p2_fc --> p2_fd
p2_bj | p2_bi --> p2_bk
p2_as >> 5 --> p2_av
p2_hu << 15 --> p2_hy
~p2_gs --> p2_gt
p2_fs & p2_fu --> p2_fv
p2_dh & p2_dj --> p2_dk
p2_bz & p2_cb --> p2_cc
p2_dy >> 1 --> p2_er
p2_hc | p2_hd --> p2_he
p2_fo | p2_fz --> p2_ga
p2_t | p2_s --> p2_u
p2_b >> 2 --> p2_d
~p2_jy --> p2_jz
p2_hz >> 2 --> p2_ia
p2_kk & p2_kv --> p2_kx
p2_ga & p2_gc --> p2_gd
p2_fl << 1 --> p2_gf
p2_bn & p2_by --> p2_ca
~p2_hr --> p2_hs
~p2_bs --> p2_bt
p2_lf >> 3 --> p2_lh
p2_au & p2_av --> p2_ax
1 & p2_gd --> p2_ge
p2_jr | p2_js --> p2_jt
p2_fw & p2_fy --> p2_fz
~p2_iz --> p2_ja
p2_c << 1 --> p2_t
p2_dy >> 5 --> p2_eb
p2_bp | p2_bq --> p2_br
~p2_h --> p2_i
1 & p2_ds --> p2_dt
p2_ab & p2_ad --> p2_ae
p2_ap << 1 --> p2_bj
p2_br & p2_bt --> p2_bu
~p2_ca --> p2_cb
~p2_el --> p2_em
p2_s << 15 --> p2_w
p2_gk | p2_gq --> p2_gr
p2_ff & p2_fh --> p2_fi
p2_kf << 15 --> p2_kj
p2_fp & p2_fv --> p2_fx
p2_lh | p2_li --> p2_lj
p2_bn >> 3 --> p2_bp
p2_jp | p2_ka --> p2_kb
p2_lw | p2_lv --> p2_lx
p2_iy & p2_ja --> p2_jb
p2_dy | p2_ej --> p2_ek
1 & p2_bh --> p2_bi
~p2_kt --> p2_ku
p2_ao | p2_an --> p2_ap
p2_ia & p2_ig --> p2_ii
~p2_ey --> p2_ez
p2_bn >> 1 --> p2_cg
p2_fk | p2_fj --> p2_fl
p2_ce | p2_cd --> p2_cf
p2_eu & p2_fa --> p2_fc
p2_kg | p2_kf --> p2_kh
p2_jr & p2_js --> p2_ju
p2_iu >> 3 --> p2_iw
p2_df & p2_dg --> p2_di
p2_dl & p2_dn --> p2_do
p2_la << 15 --> p2_le
p2_fo >> 1 --> p2_gh
~p2_gw --> p2_gx
~p2_gb --> p2_gc
p2_ir << 1 --> p2_jl
p2_x & p2_ai --> p2_ak
p2_he >> 5 --> p2_hh
1 & p2_lu --> p2_lv
~p2_ft --> p2_fu
p2_gh | p2_gi --> p2_gj
p2_lf >> 5 --> p2_li
p2_x >> 3 --> p2_z
p2_b >> 3 --> p2_e
p2_he >> 2 --> p2_hf
~p2_fx --> p2_fy
p2_jt & p2_jv --> p2_jw
p2_hx | p2_hy --> p2_hz
p2_jp & p2_ka --> p2_kc
p2_fb & p2_fd --> p2_fe
p2_hz | p2_ik --> p2_il
p2_ci >> 1 --> p2_db
p2_fo & p2_fz --> p2_gb
p2_fq & p2_fr --> p2_ft
p2_gj >> 2 --> p2_gk
p2_cg | p2_ch --> p2_ci
p2_cd << 15 --> p2_ch
p2_jm << 1 --> p2_kg
p2_ih & p2_ij --> p2_ik
p2_fo >> 3 --> p2_fq
p2_fo >> 5 --> p2_fr
1 & p2_fi --> p2_fj
1 & p2_kz --> p2_la
p2_iu & p2_jf --> p2_jh
p2_cq & p2_cs --> p2_ct
p2_dv << 1 --> p2_ep
p2_hf | p2_hl --> p2_hm
p2_km & p2_kn --> p2_kp
p2_de & p2_dk --> p2_dm
p2_dd >> 5 --> p2_dg
~p2_lo --> p2_lp
~p2_ju --> p2_jv
~p2_fg --> p2_fh
p2_cm & p2_co --> p2_cp
p2_ea & p2_eb --> p2_ed
p2_dd >> 3 --> p2_df
p2_gr & p2_gt --> p2_gu
p2_ep | p2_eo --> p2_eq
p2_cj & p2_cp --> p2_cr
p2_lf | p2_lq --> p2_lr
p2_gg << 1 --> p2_ha
p2_et >> 2 --> p2_eu
~p2_jh --> p2_ji
p2_ek & p2_em --> p2_en
p2_jk << 15 --> p2_jo
p2_ia | p2_ig --> p2_ih
p2_gv & p2_gx --> p2_gy
p2_et & p2_fe --> p2_fg
p2_lh & p2_li --> p2_lk
1 & p2_io --> p2_ip
p2_kb & p2_kd --> p2_ke
p2_kk >> 5 --> p2_kn
p2_id & p2_if --> p2_ig
~p2_ls --> p2_lt
p2_dw | p2_dx --> p2_dy
p2_dd & p2_do --> p2_dq
p2_lf & p2_lq --> p2_ls
~p2_kc --> p2_kd
p2_dy & p2_ej --> p2_el
1 & p2_ke --> p2_kf
p2_et | p2_fe --> p2_ff
p2_hz >> 5 --> p2_ic
p2_dd | p2_do --> p2_dp
p2_cj | p2_cp --> p2_cq
~p2_dq --> p2_dr
p2_kk >> 1 --> p2_ld
p2_jg & p2_ji --> p2_jj
p2_he | p2_hp --> p2_hq
p2_hi & p2_hk --> p2_hl
p2_dp & p2_dr --> p2_ds
p2_dz & p2_ef --> p2_eh
p2_hz >> 3 --> p2_ib
p2_db | p2_dc --> p2_dd
p2_hw << 1 --> p2_iq
p2_he & p2_hp --> p2_hr
~p2_cr --> p2_cs
p2_lg & p2_lm --> p2_lo
p2_hv | p2_hu --> p2_hw
p2_il & p2_in --> p2_io
~p2_eh --> p2_ei
p2_gz << 15 --> p2_hd
p2_gk & p2_gq --> p2_gs
1 & p2_en --> p2_eo
~p2_kp --> p2_kq
p2_et >> 5 --> p2_ew
p2_lj & p2_ll --> p2_lm
p2_he >> 3 --> p2_hg
p2_et >> 3 --> p2_ev
p2_as & p2_bd --> p2_bf
p2_cu & p2_cw --> p2_cx
p2_jx & p2_jz --> p2_ka
p2_b | p2_n --> p2_o
p2_be & p2_bg --> p2_bh
1 & p2_ht --> p2_hu
1 & p2_gy --> p2_gz
~p2_hn --> p2_ho
p2_ck | p2_cl --> p2_cm
p2_ec & p2_ee --> p2_ef
p2_lv << 15 --> p2_lz
p2_ks & p2_ku --> p2_kv
~p2_ie --> p2_if
p2_hf & p2_hl --> p2_hn
1 & p2_r --> p2_s
p2_ib & p2_ic --> p2_ie
p2_hq & p2_hs --> p2_ht
p2_y & p2_ae --> p2_ag
~p2_ed --> p2_ee
p2_bi << 15 --> p2_bm
p2_dy >> 2 --> p2_dz
p2_ci >> 2 --> p2_cj
~p2_bf --> p2_bg
~p2_im --> p2_in
p2_ev | p2_ew --> p2_ex
p2_ib | p2_ic --> p2_id
p2_bn >> 2 --> p2_bo
p2_dd >> 2 --> p2_de
p2_bl | p2_bm --> p2_bn
p2_as >> 1 --> p2_bl
p2_ea | p2_eb --> p2_ec
p2_ln & p2_lp --> p2_lq
p2_kk >> 3 --> p2_km
p2_is | p2_it --> p2_iu
p2_iu >> 2 --> p2_iv
p2_as | p2_bd --> p2_be
p2_ip << 15 --> p2_it
p2_iw | p2_ix --> p2_iy
p2_kk >> 2 --> p2_kl
~p2_bb --> p2_bc
p2_ci >> 5 --> p2_cl
p2_ly | p2_lz --> p2_ma
p2_z & p2_aa --> p2_ac
p2_iu >> 1 --> p2_jn
p2_cy << 15 --> p2_dc
p2_cf << 1 --> p2_cz
p2_as >> 3 --> p2_au
p2_cz | p2_cy --> p2_da
p2_kw & p2_ky --> p2_kz
p2_lx --> p2_a
p2_iw & p2_ix --> p2_iz
p2_lr & p2_lt --> p2_lu
p2_jp >> 5 --> p2_js
p2_aw & p2_ay --> p2_az
p2_jc & p2_je --> p2_jf
p2_lb | p2_la --> p2_lc
~p2_cn --> p2_co
p2_kh << 1 --> p2_lb
1 & p2_jj --> p2_jk
p2_y | p2_ae --> p2_af
p2_ck & p2_cl --> p2_cn
p2_kk | p2_kv --> p2_kw
~p2_cv --> p2_cw
p2_kl & p2_kr --> p2_kt
p2_iu | p2_jf --> p2_jg
p2_at & p2_az --> p2_bb
p2_jp >> 2 --> p2_jq
p2_iv & p2_jb --> p2_jd
p2_jn | p2_jo --> p2_jp
p2_x | p2_ai --> p2_aj
p2_ba & p2_bc --> p2_bd
p2_jl | p2_jk --> p2_jm
p2_b >> 1 --> p2_v
p2_o & p2_q --> p2_r
~p2_p --> p2_q
p2_k & p2_m --> p2_n
p2_as >> 2 --> p2_at





