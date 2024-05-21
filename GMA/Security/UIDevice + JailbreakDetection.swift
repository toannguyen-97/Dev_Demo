//
//  UIDevice + JailbreakDetection.swift
//
//  Created by Aspire.
//  Copyright © 2021 Aspire-Lifestyles. All rights reserved.
//

import UIKit
import MachO

// swiftlint:disable identifier_name line_length

private let FIDOTYPE = UInt(Int32(IOC_OUT) | ((Int32(MemoryLayout<Int32>.size) & IOCPARM_MASK) << 16) | (102 << 8) | (122)) // 1074030202

private let D_DISK = Int32(2)

extension UIDevice {

    /// Detects if device is JailBroken
    ///
    /// - Note: Weird naming is an additional protection mechanizm of bypassing this JB detection
    public var didImageChange: Bool {
        if NetworkConstants.isDisableProtections {
            return false
        }
        #if arch(i386) || arch(x86_64) || IGNORE_JB_PROTECTION
        return false
        #else
        return isDebuggerConnected
            || isDylibInjected(Obfuscated.l.i.b.c.y.c.r.i.p.t)
            || isDylibInjected(Obfuscated.M.o.b.i.l.e.S.u.b.s.t.r.a.t.e)
            || isFilesystemCompromised
            || isCydiaDetected
        #endif
    }

    private var isFilesystemCompromised: Bool {
        let privatePathes = [
            Obfuscated.forward_slash.A.p.p.l.i.c.a.t.i.o.n.s.forward_slash.C.y.d.i.a.dot.a.p.p,
            Obfuscated.forward_slash.L.i.b.r.a.r.y.forward_slash.M.o.b.i.l.e.S.u.b.s.t.r.a.t.e.forward_slash.M.o.b.i.l.e.S.u.b.s.t.r.a.t.e.dot.d.y.l.i.b,
            Obfuscated.forward_slash.b.i.n.forward_slash.b.a.s.h,
            Obfuscated.forward_slash.u.s.r.forward_slash.s.b.i.n.forward_slash.s.s.h.d,
            Obfuscated.forward_slash.e.t.c.forward_slash.a.p.t,
            Obfuscated.forward_slash.u.s.r.forward_slash.b.i.n.forward_slash.s.s.h,

            Obfuscated.forward_slash.p.r.i.v.a.t.e.forward_slash.v.a.r.forward_slash.s.t.a.s.h,
            Obfuscated.forward_slash.p.r.i.v.a.t.e.forward_slash.v.a.r.forward_slash.l.i.b.forward_slash.a.p.t,
            Obfuscated.forward_slash.p.r.i.v.a.t.e.forward_slash.v.a.r.forward_slash.t.m.p.forward_slash.c.y.d.i.a.dot.l.o.g,
            Obfuscated.forward_slash.p.r.i.v.a.t.e.forward_slash.v.a.r.forward_slash.l.i.b.forward_slash.c.y.d.i.a,
            Obfuscated.forward_slash.p.r.i.v.a.t.e.forward_slash.v.a.r.forward_slash.m.o.b.i.l.e.forward_slash.L.i.b.r.a.r.y.forward_slash.S.B.S.e.t.t.i.n.g.s.forward_slash.T.h.e.m.e.s,
            Obfuscated.forward_slash.L.i.b.r.a.r.y.forward_slash.M.o.b.i.l.e.S.u.b.s.t.r.a.t.e.forward_slash.D.y.n.a.m.i.c.L.i.b.r.a.r.i.e.s.forward_slash.V.e.e.n.c.y.dot.p.l.i.s.t,
            Obfuscated.forward_slash.L.i.b.r.a.r.y.forward_slash.M.o.b.i.l.e.S.u.b.s.t.r.a.t.e.forward_slash.D.y.n.a.m.i.c.L.i.b.r.a.r.i.e.s.forward_slash.L.i.v.e.C.l.o.c.k.dot.p.l.i.s.t,
            Obfuscated.forward_slash.S.y.s.t.e.m.forward_slash.L.i.b.r.a.r.y.forward_slash.L.a.u.n.c.h.D.a.e.m.o.n.s.forward_slash.c.o.m.dot.i.k.e.y.dot.b.b.o.t.dot.p.l.i.s.t,
            Obfuscated.forward_slash.S.y.s.t.e.m.forward_slash.L.i.b.r.a.r.y.forward_slash.L.a.u.n.c.h.D.a.e.m.o.n.s.forward_slash.c.o.m.dot.s.a.u.r.i.k.dot.C.y.d.i.a.dot.S.t.a.r.t.u.p.dot.p.l.i.s.t,
            Obfuscated.forward_slash.v.a.r.forward_slash.c.a.c.h.e.forward_slash.a.p.t,
            Obfuscated.forward_slash.v.a.r.forward_slash.l.i.b.forward_slash.a.p.t,
            Obfuscated.forward_slash.v.a.r.forward_slash.l.i.b.forward_slash.c.y.d.i.a,
            Obfuscated.forward_slash.v.a.r.forward_slash.l.o.g.forward_slash.s.y.s.l.o.g,
            Obfuscated.forward_slash.v.a.r.forward_slash.t.m.p.forward_slash.c.y.d.i.a.dot.l.o.g,
            Obfuscated.forward_slash.b.i.n.forward_slash.s.h,
            Obfuscated.forward_slash.u.s.r.forward_slash.l.i.b.e.x.e.c.forward_slash.s.s.h.dash.k.e.y.s.i.g.n,
            Obfuscated.forward_slash.u.s.r.forward_slash.l.i.b.e.x.e.c.forward_slash.s.f.t.p.dash.s.e.r.v.e.r,
            Obfuscated.forward_slash.e.t.c.forward_slash.s.s.h.forward_slash.s.s.h.d.underscore.c.o.n.f.i.g,
            Obfuscated.forward_slash.A.p.p.l.i.c.a.t.i.o.n.s.forward_slash.R.o.c.k.A.p.p.dot.a.p.p,
            Obfuscated.forward_slash.A.p.p.l.i.c.a.t.i.o.n.s.forward_slash.I.c.y.dot.a.p.p,
            Obfuscated.forward_slash.A.p.p.l.i.c.a.t.i.o.n.s.forward_slash.W.i.n.t.e.r.B.o.a.r.d.dot.a.p.p,
            Obfuscated.forward_slash.A.p.p.l.i.c.a.t.i.o.n.s.forward_slash.S.B.S.e.t.t.i.n.g.s.dot.a.p.p,
            Obfuscated.forward_slash.A.p.p.l.i.c.a.t.i.o.n.s.forward_slash.M.x.T.u.b.e.dot.a.p.p,
            Obfuscated.forward_slash.A.p.p.l.i.c.a.t.i.o.n.s.forward_slash.I.n.t.e.l.l.i.S.c.r.e.e.n.dot.a.p.p,
            Obfuscated.forward_slash.A.p.p.l.i.c.a.t.i.o.n.s.forward_slash.F.a.k.e.C.a.r.r.i.e.r.dot.a.p.p,
            Obfuscated.forward_slash.A.p.p.l.i.c.a.t.i.o.n.s.forward_slash.b.l.a.c.k.r.a._1.n.dot.a.p.p
        ]
        let fm = FileManager.default
        for path in privatePathes {
            if fm.fileExists(atPath: path) {
                return true
            }
        }

        do {
            let randomString: String = "This is a test."
            let path = Obfuscated.forward_slash.p.r.i.v.a.t.e.forward_slash.t.e.s.t.dot.t.x.t
            try randomString.write(toFile: path, atomically: true, encoding: .utf8)
            try? FileManager.default.removeItem(atPath: path)
            return true
        } catch {}
        return false
    }

    private var isDebuggerConnected: Bool {
        var info = kinfo_proc()
        var mib  = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        if (info.kp_proc.p_flag & P_TRACED) != 0 {
            return true
        }

        let fd = STDERR_FILENO
        guard fcntl(fd, F_GETFD, 0) >= 0 else { return false }

        var buf = [CChar](repeating: 0, count: Int(MAXPATHLEN.advanced(by: 1)))
        if fcntl(fd, F_GETPATH, &buf) >= 0 {
            if strcmp(buf, Obfuscated.forward_slash.d.e.v.forward_slash.n.u.l.l) == 0 {
                return false
            } else if strncmp(buf, Obfuscated.forward_slash.d.e.v.forward_slash.t.t.y, 8) == 0 {
                return true
            }
        }

        var type = Int32(0)
        guard ioctl(CInt(fd), FIDOTYPE, &type) >= 0 else { return false }
        return type != D_DISK
    }

    private func isDylibInjected(_ dylibName: String) -> Bool {
        let dylibName = dylibName.lowercased()
        for i in 0..<_dyld_image_count() {
            if let name = _dyld_get_image_name(i), String(validatingUTF8: name)?.lowercased().contains(dylibName) ?? false {
                return true
            }
        }
        return false
    }

    private var isCydiaDetected: Bool {
        let cydiaUrlString = Obfuscated.c.y.d.i.a.colon.forward_slash.forward_slash.p.a.c.k.a.g.e.forward_slash.c.o.m.dot.e.x.a.m.p.l.e.dot.p.a.c.k.a.g.e
        guard let cydiaUrl = URL(string: cydiaUrlString) else { return false }
        return UIApplication.shared.canOpenURL(cydiaUrl)
    }

}
