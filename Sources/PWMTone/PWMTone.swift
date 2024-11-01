import SwiftIO

public final class PWMTone {
    let pwm: PWMOut
    var bpm: Float
    var noteGap: Float
    var fixedHalfStep = 0

    var beatDuration: Float {
        60.0 / bpm * 1000.0
    }

    private let frequencyTable: [Int: Float] = [
        1	:	27.5	,
        2	:	29.1352	,
        3	:	30.8677	,
        4	:	32.7032	,
        5	:	34.6478	,
        6	:	36.7081	,
        7	:	38.8909	,
        8	:	41.2034	,
        9	:	43.6535	,
        10	:	46.2493	,
        11	:	48.9994	,
        12	:	51.9131	,
        13	:	55	,
        14	:	58.2705	,
        15	:	61.7354	,
        16	:	65.4064	,
        17	:	69.2957	,
        18	:	73.4162	,
        19	:	77.7817	,
        20	:	82.4069	,
        21	:	87.3071	,
        22	:	92.4986	,
        23	:	97.9989	,
        24	:	103.826	,
        25	:	110	,
        26	:	116.541	,
        27	:	123.471	,
        28	:	130.813	,
        29	:	138.591	,
        30	:	146.832	,
        31	:	155.563	,
        32	:	164.814	,
        33	:	174.614	,
        34	:	184.997	,
        35	:	195.998	,
        36	:	207.652	,
        37	:	220	,
        38	:	233.082	,
        39	:	246.942	,
        40	:	261.626	,
        41	:	277.183	,
        42	:	293.665	,
        43	:	311.127	,
        44	:	329.628	,
        45	:	349.228	,
        46	:	369.994	,
        47	:	391.995	,
        48	:	415.305	,
        49	:	440	,
        50	:	466.164	,
        51	:	493.883	,
        52	:	523.251	,
        53	:	554.365	,
        54	:	587.33	,
        55	:	622.254	,
        56	:	659.255	,
        57	:	698.456	,
        58	:	739.989	,
        59	:	783.991	,
        60	:	830.609	,
        61	:	880	,
        62	:	932.328	,
        63	:	987.767	,
        64	:	1046.5	,
        65	:	1108.73	,
        66	:	1174.66	,
        67	:	1244.51	,
        68	:	1318.51	,
        69	:	1396.91	,
        70	:	1479.98	,
        71	:	1567.98	,
        72	:	1661.22	,
        73	:	1760	,
        74	:	1864.66	,
        75	:	1975.53	,
        76	:	2093	,
        77	:	2217.46	,
        78	:	2349.32	,
        79	:	2489.02	,
        80	:	2637.02	,
        81	:	2793.83	,
        82	:	2959.96	,
        83	:	3135.96	,
        84	:	3322.44	,
        85	:	3520	,
        86	:	3729.31	,
        87	:	3951.07	,
        88	:	4186.01 ,
    ]

    public enum Note: Int {
        case	A0	=	1
        case	AS0	=	2
        case	B0	=	3
        case	C1	=	4
        case	CS1	=	5
        case	D1	=	6
        case	DS1	=	7
        case	E1	=	8
        case	F1	=	9
        case	FS1	=	10
        case	G1	=	11
        case	GS1	=	12
        case	A1	=	13
        case	AS1	=	14
        case	B1	=	15
        case	C2	=	16
        case	CS2	=	17
        case	D2	=	18
        case	DS2	=	19
        case	E2	=	20
        case	F2	=	21
        case	FS2	=	22
        case	G2	=	23
        case	GS2	=	24
        case	A2	=	25
        case	AS2	=	26
        case	B2	=	27
        case	C3	=	28
        case	CS3	=	29
        case	D3	=	30
        case	DS3	=	31
        case	E3	=	32
        case	F3	=	33
        case	FS3	=	34
        case	G3	=	35
        case	GS3	=	36
        case	A3	=	37
        case	AS3	=	38
        case	B3	=	39
        case	C4	=	40
        case	CS4	=	41
        case	D4	=	42
        case	DS4	=	43
        case	E4	=	44
        case	F4	=	45
        case	FS4	=	46
        case	G4	=	47
        case	GS4	=	48
        case	A4	=	49
        case	AS4	=	50
        case	B4	=	51
        case	C5	=	52
        case	CS5	=	53
        case	D5	=	54
        case	DS5	=	55
        case	E5	=	56
        case	F5	=	57
        case	FS5	=	58
        case	G5	=	59
        case	GS5	=	60
        case	A5	=	61
        case	AS5	=	62
        case	B5	=	63
        case	C6 	=	64
        case	CS6	=	65
        case	D6 	=	66
        case	DS6	=	67
        case	E6 	=	68
        case	F6 	=	69
        case	FS6	=	70
        case	G6 	=	71
        case	GS6	=	72
        case	A6 	=	73
        case	AS6	=	74
        case	B6 	=	75
        case	C7 	=	76
        case	CS7	=	77
        case	D7 	=	78
        case	DS7	=	79
        case	E7 	=	80
        case	F7 	=	81
        case	FS7	=	82
        case	G7 	=	83
        case	GS7	=	84
        case	A7 	=	85
        case	AS7	=	86
        case	B7 	=	87
        case	C8	=	88
        case    rest =  -1
    }

    public typealias Track = [(note: Note, noteValue: Int)]

    public init(_ pwm: PWMOut, bpm: Int = 96, noteGap: Float = 0.1) {
        guard bpm > 0 else {
            print("bmp must be positive")
            fatalError()
        }

        self.pwm = pwm
        self.bpm = Float(bpm)
        self.noteGap = noteGap
    }

    public func setBPM(_ bpm: Int) {
        guard bpm > 0 else {return}
        self.bpm = Float(bpm)
    }

    public func setFixedHalfStep(_ value: Int) {
        fixedHalfStep = value
    }

    public func setNoteGap(_ percentage: Float) {
        guard percentage > 0 && percentage < 1.0 else {
            return
        }

        noteGap = percentage
    }

    public func play(note: Note, noteValue: Int = 4, halfStep: Int = 0) {
        guard noteValue > 0 else {
            return
        }
        let duration  = beatDuration * (4.0 / Float(noteValue))
        let frequency = frequencyTable[note.rawValue + fixedHalfStep + halfStep]

        tone(frequency, duration * (1 - noteGap))
        rest(duration * noteGap)
    }

    // public func play(note: (Note, Int), halfStep: Int = 0) {
    //     play(note: note.0, noteValue: note.1, halfStep: halfStep)
    // }

    public func play(track: Track, halfStep: Int = 0) {
        for note in track {
            play(note: note.0, noteValue: note.1, halfStep: halfStep)
        }
    }
}

extension PWMTone {
    func tone(_ frequency: Float?, _ duration: Float, suspend: Bool = false) {
        let period: Int

        if let frequency = frequency {
            period = Int(1_000_000.0 / frequency)
        } else {
            period = 0
        }

        pwm.set(period: period, pulse: period / 2)
        sleep(ms: Int(duration))
        if suspend {
            pwm.suspend()
        }
    }

    func rest(_ duration: Float) {
        pwm.suspend()
        sleep(ms: Int(duration))
    }    
}