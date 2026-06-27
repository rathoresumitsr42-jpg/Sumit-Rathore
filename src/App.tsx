import React, { useState, useEffect, useRef } from "react";
import {
  Building2,
  UserPlus,
  Receipt,
  Lightbulb,
  TrendingUp,
  Settings as SettingsIcon,
  CreditCard,
  Plus,
  Search,
  LogOut,
  QrCode,
  Calendar,
  Flame,
  CheckCircle2,
  AlertTriangle,
  Trash2,
  Copy,
  Code,
  Smartphone,
  Laptop,
  ChevronRight,
  Download,
  LayoutDashboard,
  Menu,
  Users,
  Bolt,
  FileText,
  Check,
  Bell,
  Layers,
  Phone,
  ArrowRight,
  RefreshCw,
  Clock
} from "lucide-react";

// --- TYPE DEFINITIONS ---
interface Room {
  roomNumber: string;
  floor: number;
  isOccupied: boolean;
  currentTenantId?: string;
  currentTenantName?: string;
  baseRentAmount: number;
  lastMeterReading: number;
  pendingRent: number;
  pendingElectricity: number;
}

interface Tenant {
  id: string;
  name: string;
  phone: string;
  roomNumber: string;
  joinDate: string;
  securityDeposit: number;
  isActive: boolean;
  initialMeterReading: number;
}

interface Payment {
  id: string;
  roomNumber: string;
  tenantName: string;
  date: string;
  amountPaid: number;
  rentComponent: number;
  electricityComponent: number;
  previousReading: number;
  currentReading: number;
  unitsConsumed: number;
  paymentMode: string;
  monthYear: string;
  transactionId?: string;
  remarks?: string;
}

interface ElectricityReading {
  id: string;
  roomNumber: string;
  monthYear: string;
  previousReading: number;
  currentReading: number;
  ratePerUnit: number;
  readingDate: string;
  isBilled: boolean;
  isPaid: boolean;
}

// --- FLUTTER CODE DIRECTORY MAP ---
const FLUTTER_CODEBASE = {
  "pubspec.yaml": {
    path: "pubspec.yaml",
    language: "yaml",
    code: `name: shree_ram_rooms_manager
description: A premium rental management application for managing 36 rooms, tenants, payments, electricity meter readings, and revenue reports.
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  google_fonts: ^6.1.0
  intl: ^0.19.0
  fl_chart: ^0.66.0
  qr_flutter: ^4.1.0
  shared_preferences: ^2.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true`
  },
  "lib/main.dart": {
    path: "lib/main.dart",
    language: "dart",
    code: `import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/room_model.dart';
import 'models/tenant_model.dart';
import 'models/payment_model.dart';
import 'models/electricity_model.dart';
import 'screens/dashboard_screen.dart';
import 'screens/rooms_screen.dart';
import 'screens/tenants_screen.dart';
import 'screens/payments_screen.dart';
import 'screens/electricity_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const ShreeRamRoomsManagerApp());
}

class ShreeRamRoomsManagerApp extends StatelessWidget {
  const ShreeRamRoomsManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shree Ram Rooms Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}`
  },
  "lib/theme/app_theme.dart": {
    path: "lib/theme/app_theme.dart",
    language: "dart",
    code: `import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFF6D00); // Saffron Orange
  static const Color primaryDarkColor = Color(0xFFE65100);
  static const Color secondaryColor = Color(0xFF2E7D32); // Emerald Green
  static const Color secondaryDarkColor = Color(0xFF1B5E20);
  static const Color backgroundColor = Color(0xFFFBFDFA);
  static const Color surfaceColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: surfaceColor,
      ),
    );
  }
}`
  },
  "lib/models/room_model.dart": {
    path: "lib/models/room_model.dart",
    language: "dart",
    code: `class Room {
  final String roomNumber;
  final int floor;
  final bool isOccupied;
  final String? currentTenantId;
  final String? currentTenantName;
  final double baseRentAmount;
  final double lastMeterReading;
  final double pendingRent;
  final double pendingElectricity;

  Room({
    required this.roomNumber,
    required this.floor,
    required this.isOccupied,
    this.currentTenantId,
    this.currentTenantName,
    required this.baseRentAmount,
    required this.lastMeterReading,
    this.pendingRent = 0.0,
    this.pendingElectricity = 0.0,
  });
}`
  },
  "lib/screens/dashboard_screen.dart": {
    path: "lib/screens/dashboard_screen.dart",
    language: "dart",
    code: `import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/room_model.dart';
import '../models/payment_model.dart';

class DashboardScreen extends StatelessWidget {
  final List<Room> rooms;
  final List<Payment> payments;

  const DashboardScreen({super.key, required this.rooms, required this.payments});

  @override
  Widget build(BuildContext context) {
    // Dynamic calculation cards and recents payment list views...
  }
}`
  },
  "lib/screens/rooms_screen.dart": {
    path: "lib/screens/rooms_screen.dart",
    language: "dart",
    code: `import 'package:flutter/material.dart';
import '../models/room_model.dart';

class RoomsScreen extends StatefulWidget {
  final List<Room> rooms;
  const RoomsScreen({super.key, required this.rooms});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}`
  },
  "lib/screens/payments_screen.dart": {
    path: "lib/screens/payments_screen.dart",
    language: "dart",
    code: `import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/payment_model.dart';

class PaymentsScreen extends StatefulWidget {
  final List<Payment> payments;
  final String upiId;

  const PaymentsScreen({super.key, required this.payments, required this.upiId});
}`
  }
};

export default function App() {
  // --- STATE SYSTEM ---
  const [rooms, setRooms] = useState<Room[]>([]);
  const [tenants, setTenants] = useState<Tenant[]>([]);
  const [payments, setPayments] = useState<Payment[]>([]);
  const [electricityReadings, setElectricityReadings] = useState<ElectricityReading[]>([]);

  // Settings state
  const [electricityRate, setElectricityRate] = useState<number>(8.0);
  const [upiId, setUpiId] = useState<string>("rathoresumit.SR42@okaxis");
  const [ownerName, setOwnerName] = useState<string>("Sumit Rathore");
  const [buildingName, setBuildingName] = useState<string>("Shree Ram Residency");

  // UI States
  const [activeTab, setActiveTab] = useState<string>("Dashboard"); // Dashboard, Rooms, Payments, Reports, Settings
  const [sidebarOpen, setSidebarOpen] = useState<boolean>(false);
  const [selectedRoom, setSelectedRoom] = useState<Room | null>(null);
  const [showRoomDetails, setShowRoomDetails] = useState<boolean>(false);
  const [currentSystemTime, setCurrentSystemTime] = useState<string>("");
  const [previewMode, setPreviewMode] = useState<"phone" | "fullscreen">("phone");
  const [filterRoomStatus, setFilterRoomStatus] = useState<"All" | "Occupied" | "Vacant" | "Pending">("All");

  // Dialog / Action overlays
  const [showRecordPaymentModal, setShowRecordPaymentModal] = useState<boolean>(false);
  const [showLogMeterModal, setShowLogMeterModal] = useState<boolean>(false);
  const [showCheckInModal, setShowCheckInModal] = useState<boolean>(false);
  const [showQrModal, setShowQrModal] = useState<boolean>(false);
  const [showReportPreviewModal, setShowReportPreviewModal] = useState<boolean>(false);

  // Form input states
  const [paymentForm, setPaymentForm] = useState({
    roomNumber: "",
    rentPaid: 0,
    elecPaid: 0,
    mode: "UPI"
  });
  const [meterForm, setMeterForm] = useState({
    roomNumber: "",
    currentReading: 0
  });
  const [checkInForm, setCheckInForm] = useState({
    roomNumber: "",
    tenantName: "",
    phone: "",
    deposit: 16000,
    baseRent: 8000
  });
  const [qrAmount, setQrAmount] = useState<number>(0);

  // Search filter
  const [tenantSearchQuery, setTenantSearchQuery] = useState<string>("");

  // Code Explorer states
  const [selectedCodeFile, setSelectedCodeFile] = useState<keyof typeof FLUTTER_CODEBASE>("lib/main.dart");
  const [copiedStatus, setCopiedStatus] = useState<boolean>(false);

  // --- INITIALIZE LIVE DATA ---
  useEffect(() => {
    // Sync clock
    const updateClock = () => {
      const now = new Date();
      setCurrentSystemTime(
        now.toLocaleTimeString("en-US", { hour: "numeric", minute: "2-digit", hour12: true })
      );
    };
    updateClock();
    const interval = setInterval(updateClock, 1000);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    // Load from local storage or pre-seed
    const localRooms = localStorage.getItem("srr_rooms");
    const localTenants = localStorage.getItem("srr_tenants");
    const localPayments = localStorage.getItem("srr_payments");
    const localElectricity = localStorage.getItem("srr_electricity");
    const localSettings = localStorage.getItem("srr_settings");

    if (localRooms && localTenants && localPayments) {
      setRooms(JSON.parse(localRooms));
      setTenants(JSON.parse(localTenants));
      setPayments(JSON.parse(localPayments));
      if (localElectricity) setElectricityReadings(JSON.parse(localElectricity));
      if (localSettings) {
        const settings = JSON.parse(localSettings);
        setElectricityRate(settings.electricityRate || 8.0);
        setUpiId(settings.upiId || "rathoresumit.SR42@okaxis");
        setOwnerName(settings.ownerName || "Sumit Rathore");
        setBuildingName(settings.buildingName || "Shree Ram Residency");
      }
    } else {
      // Pre-seed 36 rooms (Floors 1-4, 9 rooms per floor)
      const seededRooms: Room[] = [];
      const seededTenants: Tenant[] = [];
      const seededPayments: Payment[] = [];

      const firstNames = ["Amit", "Rakesh", "Sanjay", "Vijay", "Rahul", "Priya", "Anjali", "Ramesh", "Deepak", "Karan"];
      const lastNames = ["Sharma", "Verma", "Yadav", "Singh", "Patel", "Gupta", "Rao", "Mishra", "Joshi", "Choudhary"];

      for (let floor = 1; floor <= 4; floor++) {
        for (let r = 1; r <= 9; r++) {
          const roomNum = `${floor}${r.toString().padStart(2, "0")}`;
          const baseRent = floor === 1 ? 7500 : floor === 2 ? 8000 : floor === 3 ? 8500 : 9000;
          const isOccupied = r % 3 !== 0; // 66% occupancy
          let tenantId = undefined;
          let tenantName = undefined;
          let pendingRent = 0;
          let pendingElectricity = 0;
          const lastReading = 150 + r * 45;

          if (isOccupied) {
            tenantId = `T_${roomNum}`;
            tenantName = `${firstNames[(r - 1) % firstNames.length]} ${lastNames[(floor + r) % lastNames.length]}`;
            
            // Seed some partial outstanding dues for realistic bookkeeping
            if (r % 4 === 0) {
              pendingRent = baseRent;
              pendingElectricity = 240;
            } else if (r % 5 === 0) {
              pendingRent = baseRent / 2;
              pendingElectricity = 120;
            }

            seededTenants.push({
              id: tenantId,
              name: tenantName,
              phone: `+91 98${roomNum}0123`,
              roomNumber: roomNum,
              joinDate: new Date(Date.now() - 30 * floor * 24 * 60 * 60 * 1000).toISOString().split("T")[0],
              securityDeposit: baseRent * 2,
              isActive: true,
              initialMeterReading: lastReading - 120
            });
          }

          seededRooms.push({
            roomNumber: roomNum,
            floor,
            isOccupied,
            currentTenantId: tenantId,
            currentTenantName: tenantName,
            baseRentAmount: baseRent,
            lastMeterReading: lastReading,
            pendingRent,
            pendingElectricity
          });
        }
      }

      // Pre-seed some recent payments (last 12 transactions)
      const months = ["June 2026", "May 2026"];
      let pCount = 1;
      seededRooms.forEach((room) => {
        if (room.isOccupied && pCount <= 12) {
          seededPayments.push({
            id: `P_${pCount}`,
            roomNumber: room.roomNumber,
            tenantName: room.currentTenantName || "",
            date: new Date(Date.now() - pCount * 1.5 * 24 * 60 * 60 * 1000).toISOString().split("T")[0],
            amountPaid: room.baseRentAmount + 320,
            rentComponent: room.baseRentAmount,
            electricityComponent: 320,
            previousReading: room.lastMeterReading - 40,
            currentReading: room.lastMeterReading,
            unitsConsumed: 40,
            paymentMode: pCount % 3 === 0 ? "UPI" : pCount % 3 === 1 ? "Cash" : "Bank Transfer",
            monthYear: months[pCount % 2],
            transactionId: pCount % 3 !== 1 ? `TXN72901${900 + pCount}` : undefined,
            remarks: "Saffron rent and meter ledger cleared."
          });
          pCount++;
        }
      });

      // Save seeds
      localStorage.setItem("srr_rooms", JSON.stringify(seededRooms));
      localStorage.setItem("srr_tenants", JSON.stringify(seededTenants));
      localStorage.setItem("srr_payments", JSON.stringify(seededPayments));
      setRooms(seededRooms);
      setTenants(seededTenants);
      setPayments(seededPayments);
    }
  }, []);

  // Sync back to local storage on mutation
  const saveState = (updatedRooms: Room[], updatedTenants: Tenant[], updatedPayments: Payment[]) => {
    localStorage.setItem("srr_rooms", JSON.stringify(updatedRooms));
    localStorage.setItem("srr_tenants", JSON.stringify(updatedTenants));
    localStorage.setItem("srr_payments", JSON.stringify(updatedPayments));
    setRooms(updatedRooms);
    setTenants(updatedTenants);
    setPayments(updatedPayments);
  };

  const handleUpdateSettings = (rate: number, upi: string, owner: string, building: string) => {
    setElectricityRate(rate);
    setUpiId(upi);
    setOwnerName(owner);
    setBuildingName(building);
    localStorage.setItem("srr_settings", JSON.stringify({ electricityRate: rate, upiId: upi, ownerName: owner, buildingName: building }));
  };

  // --- ACTIONS SYSTEM ---
  const handleAddTenant = (roomNum: string, name: string, phone: string, deposit: number, baseRent: number) => {
    const tenantId = `T_${roomNum}_${Date.now()}`;
    const newTenant: Tenant = {
      id: tenantId,
      name,
      phone,
      roomNumber: roomNum,
      joinDate: new Date().toISOString().split("T")[0],
      securityDeposit: deposit,
      isActive: true,
      initialMeterReading: 100 // starting reading
    };

    const updatedTenants = [...tenants, newTenant];
    const updatedRooms = rooms.map((r) => {
      if (r.roomNumber === roomNum) {
        return {
          ...r,
          isOccupied: true,
          currentTenantId: tenantId,
          currentTenantName: name,
          baseRentAmount: baseRent,
          pendingRent: 0,
          pendingElectricity: 0
        };
      }
      return r;
    });

    saveState(updatedRooms, updatedTenants, payments);
    setShowCheckInModal(false);
    if (selectedRoom?.roomNumber === roomNum) {
      setSelectedRoom({
        ...selectedRoom,
        isOccupied: true,
        currentTenantId: tenantId,
        currentTenantName: name,
        baseRentAmount: baseRent
      });
    }
  };

  const handleCheckoutTenant = (roomNum: string) => {
    const r = rooms.find((room) => room.roomNumber === roomNum);
    if (!r) return;

    const updatedTenants = tenants.map((t) => (t.roomNumber === roomNum ? { ...t, isActive: false } : t));
    const updatedRooms = rooms.map((room) => {
      if (room.roomNumber === roomNum) {
        return {
          ...room,
          isOccupied: false,
          currentTenantId: undefined,
          currentTenantName: undefined,
          pendingRent: 0,
          pendingElectricity: 0
        };
      }
      return room;
    });

    saveState(updatedRooms, updatedTenants, payments);
    setShowRoomDetails(false);
    setSelectedRoom(null);
  };

  const handleRecordPayment = (roomNum: string, rentPaid: number, elecPaid: number, mode: string) => {
    const r = rooms.find((room) => room.roomNumber === roomNum);
    if (!r) return;

    const newPayment: Payment = {
      id: `P_${Date.now()}`,
      roomNumber: roomNum,
      tenantName: r.currentTenantName || "Unknown Tenant",
      date: new Date().toISOString().split("T")[0],
      amountPaid: rentPaid + elecPaid,
      rentComponent: rentPaid,
      electricityComponent: elecPaid,
      previousReading: r.lastMeterReading,
      currentReading: r.lastMeterReading,
      unitsConsumed: 0,
      paymentMode: mode,
      monthYear: "June 2026",
      remarks: "Logged via Payment Panel"
    };

    const updatedPayments = [newPayment, ...payments];
    const updatedRooms = rooms.map((room) => {
      if (room.roomNumber === roomNum) {
        return {
          ...room,
          pendingRent: Math.max(0, room.pendingRent - rentPaid),
          pendingElectricity: Math.max(0, room.pendingElectricity - elecPaid)
        };
      }
      return room;
    });

    saveState(updatedRooms, tenants, updatedPayments);
    setShowRecordPaymentModal(false);
    
    // Update active modal selected room
    const updatedSelected = updatedRooms.find(item => item.roomNumber === roomNum);
    if (updatedSelected) {
      setSelectedRoom(updatedSelected);
    }
  };

  const handleLogElectricity = (roomNum: string, currentReading: number) => {
    const r = rooms.find((room) => room.roomNumber === roomNum);
    if (!r) return;

    const consumed = Math.max(0, currentReading - r.lastMeterReading);
    const cost = consumed * electricityRate;

    const updatedRooms = rooms.map((room) => {
      if (room.roomNumber === roomNum) {
        return {
          ...room,
          lastMeterReading: currentReading,
          pendingElectricity: room.pendingElectricity + cost
        };
      }
      return room;
    });

    saveState(updatedRooms, tenants, payments);
    setShowLogMeterModal(false);

    // Update active modal selected room
    const updatedSelected = updatedRooms.find(item => item.roomNumber === roomNum);
    if (updatedSelected) {
      setSelectedRoom(updatedSelected);
    }
  };

  // --- STATS COMPUTATION ---
  const totalRoomsCount = rooms.length;
  const occupiedRoomsCount = rooms.filter((r) => r.isOccupied).length;
  const vacantRoomsCount = totalRoomsCount - occupiedRoomsCount;

  // Expected Rent = rents of all occupied rooms + outstanding balance
  const totalExpectedRent = rooms.reduce((acc, r) => acc + (r.isOccupied ? r.baseRentAmount : 0), 0) + rooms.reduce((acc, r) => acc + r.pendingRent, 0);
  const totalRentCollected = payments.filter((p) => p.monthYear === "June 2026").reduce((acc, p) => acc + p.rentComponent, 0);
  const totalPendingRent = rooms.reduce((acc, r) => acc + r.pendingRent, 0);

  const totalElectricityCollected = payments.filter((p) => p.monthYear === "June 2026").reduce((acc, p) => acc + p.electricityComponent, 0);
  const totalPendingElectricity = rooms.reduce((acc, r) => acc + r.pendingElectricity, 0);

  // --- COPIER HELPERS ---
  const copyCodeToClipboard = (codeText: string) => {
    navigator.clipboard.writeText(codeText);
    setCopiedStatus(true);
    setTimeout(() => setCopiedStatus(false), 2000);
  };

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 flex flex-col font-sans selection:bg-orange-500 selection:text-white" id="main_wrapper">
      {/* --- PREMIUM WEB HEADER --- */}
      <header className="bg-slate-950 border-b border-slate-800 px-6 py-4 flex flex-col md:flex-row justify-between items-center gap-4 shadow-xl z-20" id="global_header">
        <div className="flex items-center gap-3">
          <div className="bg-gradient-to-tr from-orange-600 to-amber-500 p-2.5 rounded-xl shadow-lg shadow-orange-500/10">
            <Building2 className="w-7 h-7 text-white" />
          </div>
          <div>
            <h1 className="text-xl font-bold bg-gradient-to-r from-orange-500 via-amber-400 to-emerald-400 bg-clip-text text-transparent">
              Shree Ram Rooms Manager
            </h1>
            <p className="text-xs text-slate-400 font-mono">
              Material Design 3 &bull; 36-Room Rental Console
            </p>
          </div>
        </div>

        <div className="flex items-center gap-4">
          {/* Simulator layout switch */}
          <div className="bg-slate-900 p-1 rounded-xl border border-slate-800 flex items-center gap-1">
            <button
              onClick={() => setPreviewMode("phone")}
              className={`px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition-all ${
                previewMode === "phone" ? "bg-orange-600 text-white shadow-md shadow-orange-600/20" : "text-slate-400 hover:text-white"
              }`}
            >
              <Smartphone className="w-3.5 h-3.5" />
              Android Frame
            </button>
            <button
              onClick={() => setPreviewMode("fullscreen")}
              className={`px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition-all ${
                previewMode === "fullscreen" ? "bg-orange-600 text-white shadow-md shadow-orange-600/20" : "text-slate-400 hover:text-white"
              }`}
            >
              <Laptop className="w-3.5 h-3.5" />
              Full Screen PWA
            </button>
          </div>

          <div className="text-xs text-slate-400 bg-slate-900/60 border border-slate-800 px-3 py-1.5 rounded-lg flex items-center gap-1.5">
            <Clock className="w-3.5 h-3.5 text-orange-500 animate-pulse" />
            <span className="font-mono text-slate-200">June 2026</span>
          </div>
        </div>
      </header>

      {/* --- CONTENT WORKSPACE --- */}
      <div className="flex-1 flex flex-col lg:flex-row overflow-hidden relative" id="workspace_container">
        {/* LEFT COLUMN: ACTIVE INTERACTIVE SIMULATOR EMULATOR */}
        <div className={`flex-1 p-6 flex items-center justify-center overflow-y-auto ${previewMode === "phone" ? "bg-slate-950/60" : "bg-slate-900"}`}>
          {previewMode === "phone" ? (
            /* --- ANDROID SMARTPHONE MOCKUP FRAME --- */
            <div className="w-[410px] h-[840px] bg-slate-950 rounded-[48px] border-[12px] border-slate-800 shadow-[0_25px_60px_-15px_rgba(0,0,0,0.8)] flex flex-col relative overflow-hidden transition-all duration-300 ring-2 ring-slate-800/50" id="android_frame">
              {/* Speaker & Sensor Notch */}
              <div className="absolute top-2 left-1/2 -translate-x-1/2 w-32 h-6 bg-slate-950 rounded-full z-30 flex items-center justify-center">
                <div className="w-12 h-1 bg-slate-800 rounded-full" />
              </div>

              {/* Status Bar */}
              <div className="bg-white text-slate-900 px-7 pt-9 pb-1.5 flex justify-between items-center text-[11px] font-bold z-20">
                <span className="font-mono">{currentSystemTime}</span>
                <div className="flex items-center gap-1.5">
                  <Flame className="w-3 h-3 text-orange-500" />
                  <span>5G</span>
                  <div className="w-5 h-2.5 border border-slate-900 rounded-sm p-0.5 flex items-center">
                    <div className="w-3.5 h-full bg-slate-900 rounded-[1px]" />
                  </div>
                </div>
              </div>

              {/* Live Flutter View */}
              <div className="flex-1 bg-slate-50 text-slate-900 flex flex-col relative overflow-hidden">
                {_renderActiveFlutterApp()}
              </div>

              {/* Bottom Gesture Bar */}
              <div className="bg-white py-3 flex items-center justify-center z-20">
                <div className="w-32 h-1.5 bg-slate-800 rounded-full" />
              </div>
            </div>
          ) : (
            /* --- FULL SCREEN FLUTTER PWA MODE --- */
            <div className="w-full h-full max-w-7xl mx-auto bg-slate-50 text-slate-900 rounded-2xl shadow-2xl flex flex-col relative overflow-hidden transition-all duration-300 border border-slate-200">
              {/* Fake web app bar */}
              <div className="bg-orange-600 text-white px-6 py-3 flex justify-between items-center shadow-md">
                <div className="flex items-center gap-2">
                  <Building2 className="w-5 h-5" />
                  <span className="font-bold text-sm tracking-wide">{buildingName} Management PWA</span>
                </div>
                <span className="text-xs font-semibold font-mono bg-orange-700 px-2 py-1 rounded">PRO MODE</span>
              </div>
              <div className="flex-1 flex flex-col relative overflow-hidden">
                {_renderActiveFlutterApp()}
              </div>
            </div>
          )}
        </div>

        {/* RIGHT COLUMN: FLUTTER CODE EXPLORER PANEL */}
        <div className="w-full lg:w-[480px] bg-slate-950 border-t lg:border-t-0 lg:border-l border-slate-800 flex flex-col overflow-hidden z-10 shadow-2xl" id="code_explorer">
          <div className="p-4 bg-slate-950 border-b border-slate-800 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Code className="w-4 h-4 text-emerald-400" />
              <span className="text-xs font-bold font-mono text-slate-200 uppercase tracking-wider">
                Flutter Code hub
              </span>
            </div>
            <button
              onClick={() => copyCodeToClipboard(FLUTTER_CODEBASE[selectedCodeFile].code)}
              className="text-xs bg-slate-900 hover:bg-slate-800 border border-slate-800 hover:border-slate-700 px-2.5 py-1.5 rounded-lg flex items-center gap-1.5 text-slate-300 hover:text-white transition-all font-semibold"
            >
              {copiedStatus ? (
                <>
                  <Check className="w-3.5 h-3.5 text-emerald-400" />
                  Copied!
                </>
              ) : (
                <>
                  <Copy className="w-3.5 h-3.5 text-slate-400" />
                  Copy File
                </>
              )}
            </button>
          </div>

          {/* Directory File Tree Tabs */}
          <div className="p-3 bg-slate-900/40 border-b border-slate-800 flex flex-wrap gap-1.5 max-h-[140px] overflow-y-auto">
            {Object.keys(FLUTTER_CODEBASE).map((filename) => {
              const isActive = selectedCodeFile === filename;
              return (
                <button
                  key={filename}
                  onClick={() => setSelectedCodeFile(filename as keyof typeof FLUTTER_CODEBASE)}
                  className={`px-2.5 py-1 rounded-md text-[11px] font-mono transition-all flex items-center gap-1.5 ${
                    isActive
                      ? "bg-gradient-to-tr from-orange-600 to-amber-500 text-white font-bold shadow-md shadow-orange-500/10"
                      : "bg-slate-950 text-slate-400 hover:bg-slate-900 border border-slate-800"
                  }`}
                >
                  <FileText className="w-3 h-3" />
                  {filename}
                </button>
              );
            })}
          </div>

          {/* Pretty Code Preview Area */}
          <div className="flex-1 overflow-auto p-4 bg-slate-950/40 font-mono text-xs text-slate-300 leading-relaxed border-b border-slate-800 relative">
            <div className="absolute top-2 right-2 bg-slate-900/80 backdrop-blur text-[10px] px-2 py-0.5 rounded border border-slate-800 text-slate-400 font-sans uppercase">
              {FLUTTER_CODEBASE[selectedCodeFile].language}
            </div>
            <pre className="whitespace-pre overflow-x-auto text-left select-all">{FLUTTER_CODEBASE[selectedCodeFile].code}</pre>
          </div>

          {/* Project Structure Tree */}
          <div className="p-4 bg-slate-950 border-t border-slate-800 text-left">
            <h3 className="text-xs font-semibold text-slate-400 font-mono uppercase tracking-wider mb-2">
              Flutter Folder Tree
            </h3>
            <div className="bg-slate-900/60 p-3 rounded-lg border border-slate-800/80 font-mono text-[11px] text-slate-400 space-y-1">
              <div>📁 shree_ram_rooms_manager/</div>
              <div className="pl-4">├── 📁 assets/</div>
              <div className="pl-8">└── 📁 images/ <span className="text-slate-600">&bull; app logos</span></div>
              <div className="pl-4">├── 📁 lib/</div>
              <div className="pl-8">├── 📁 models/ <span className="text-orange-500/80">&bull; data structures</span></div>
              <div className="pl-8">├── 📁 screens/ <span className="text-orange-500/80">&bull; UI layouts</span></div>
              <div className="pl-8">├── 📁 theme/ <span className="text-orange-500/80">&bull; saffron theme</span></div>
              <div className="pl-8">└── 📁 widgets/ <span className="text-orange-500/80">&bull; reusable widgets</span></div>
              <div className="pl-4">└── 📄 pubspec.yaml <span className="text-emerald-500">&bull; active</span></div>
            </div>
          </div>
        </div>
      </div>

      {/* --- FLOATING OVERLAYS AND MODALS --- */}
      {_renderActiveModals()}
    </div>
  );

  // ==========================================
  // --- SUB-RENDERS FOR INTERACTIVE WEB APP ---
  // ==========================================

  function _renderActiveFlutterApp() {
    return (
      <div className="flex-1 flex flex-col relative h-full select-none text-left" id="flutter_view">
        {/* Simulated Navigation Drawer Side Menu */}
        {sidebarOpen && (
          <div className="absolute inset-0 bg-black/40 z-40 transition-opacity flex">
            <div className="w-[300px] bg-white h-full shadow-2xl flex flex-col p-6 text-slate-900 border-r border-slate-100 animate-slide-in">
              {/* Header profile */}
              <div className="flex items-center gap-3 mb-6 pb-6 border-b border-slate-100">
                <div className="bg-orange-100 p-2.5 rounded-full text-orange-600">
                  <Building2 className="w-6 h-6" />
                </div>
                <div className="text-left">
                  <h4 className="font-bold text-base text-slate-800 leading-tight">
                    {buildingName}
                  </h4>
                  <p className="text-xs text-slate-500">Proprietor: {ownerName}</p>
                </div>
              </div>

              {/* Navigation Items */}
              <div className="flex-1 space-y-1.5 overflow-y-auto">
                <p className="text-[10px] font-bold text-emerald-700 tracking-wider uppercase pl-2 mb-1">
                  Primary Views
                </p>
                {[
                  { name: "Dashboard", icon: LayoutDashboard },
                  { name: "Rooms", icon: Building2 },
                  { name: "Payments", icon: CreditCard },
                  { name: "Reports", icon: TrendingUp },
                  { name: "Settings", icon: SettingsIcon }
                ].map((item) => {
                  const Icon = item.icon;
                  const isActive = activeTab === item.name;
                  return (
                    <button
                      key={item.name}
                      onClick={() => {
                        setActiveTab(item.name);
                        setSidebarOpen(false);
                      }}
                      className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition-all ${
                        isActive
                          ? "bg-orange-50 text-orange-600"
                          : "text-slate-600 hover:bg-slate-50 hover:text-slate-900"
                      }`}
                    >
                      <Icon className="w-5 h-5" />
                      {item.name}
                    </button>
                  );
                })}

                <div className="pt-4">
                  <p className="text-[10px] font-bold text-emerald-700 tracking-wider uppercase pl-2 mb-2">
                    Operational Sheets
                  </p>
                  <button
                    onClick={() => {
                      setActiveTab("Tenants List");
                      setSidebarOpen(false);
                    }}
                    className={`w-full flex items-center justify-between px-3 py-2.5 rounded-xl text-sm font-semibold transition-all ${
                      activeTab === "Tenants List"
                        ? "bg-emerald-50 text-emerald-700"
                        : "text-slate-600 hover:bg-slate-50"
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <Users className="w-5 h-5" />
                      <span>Tenants List</span>
                    </div>
                    <span className="text-[10px] font-mono font-bold bg-emerald-100 text-emerald-800 px-2 py-0.5 rounded-full">
                      {tenants.filter((t) => t.isActive).length}
                    </span>
                  </button>

                  <button
                    onClick={() => {
                      setActiveTab("Electricity Ledger");
                      setSidebarOpen(false);
                    }}
                    className={`w-full flex items-center justify-between px-3 py-2.5 rounded-xl text-sm font-semibold transition-all ${
                      activeTab === "Electricity Ledger"
                        ? "bg-emerald-50 text-emerald-700"
                        : "text-slate-600 hover:bg-slate-50"
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <Bolt className="w-5 h-5" />
                      <span>Electricity Ledger</span>
                    </div>
                  </button>
                </div>
              </div>

              {/* Version label */}
              <div className="pt-4 border-t border-slate-100 flex items-center justify-between text-[11px] text-slate-400 font-mono">
                <span>Flutter Framework v1.0</span>
                <span className="bg-orange-100 text-orange-700 font-bold px-1.5 py-0.5 rounded text-[10px]">
                  M3
                </span>
              </div>
            </div>

            {/* Tap outside to close */}
            <div className="flex-1" onClick={() => setSidebarOpen(false)} />
          </div>
        )}

        {/* --- SIMULATED FLUTTER APP BAR --- */}
        <div className="bg-white border-b border-slate-200 px-5 py-4 flex justify-between items-center shrink-0 z-10 shadow-sm">
          <div className="flex items-center gap-3">
            <button
              onClick={() => setSidebarOpen(true)}
              className="p-2 hover:bg-slate-50 border border-slate-100 rounded-xl text-slate-600 transition-all shadow-sm"
            >
              <Menu className="w-5 h-5" />
            </button>
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-orange-500 rounded-xl flex items-center justify-center text-white shrink-0 shadow-sm">
                <Building2 className="w-5.5 h-5.5" />
              </div>
              <h1 className="text-base md:text-lg font-extrabold text-slate-800 tracking-tight leading-none text-left">
                {activeTab === "Dashboard" ? (
                  <>
                    Shree Ram <span className="text-orange-600">Residency</span>
                  </>
                ) : activeTab === "Tenants List" ? (
                  <>
                    Tenants <span className="text-orange-600">Register</span>
                  </>
                ) : activeTab === "Electricity Ledger" ? (
                  <>
                    Meter <span className="text-orange-600">Ledger</span>
                  </>
                ) : (
                  <>
                    Shree Ram <span className="text-orange-600">{activeTab}</span>
                  </>
                )}
              </h1>
            </div>
          </div>

          <div className="flex items-center gap-1">
            <div className="relative">
              <button className="p-2.5 hover:bg-slate-50 border border-slate-100 rounded-xl text-slate-500 relative transition-all shadow-sm">
                <Bell className="w-5 h-5" />
                <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full" />
              </button>
            </div>
          </div>
        </div>

        {/* --- SCROLLABLE CONTAINER FOR SCREENS --- */}
        <div className="flex-1 overflow-y-auto bg-slate-50 p-5 md:p-6 lg:p-8">
          {activeTab === "Dashboard" && _renderDashboard()}
          {activeTab === "Rooms" && _renderRooms()}
          {activeTab === "Payments" && _renderPayments()}
          {activeTab === "Reports" && _renderReports()}
          {activeTab === "Settings" && _renderSettings()}
          {activeTab === "Tenants List" && _renderTenantsList()}
          {activeTab === "Electricity Ledger" && _renderElectricityLedger()}
        </div>

        {/* --- BOTTOM MATERIAL 3 NAVIGATION BAR --- */}
        <div className="bg-white border-t border-slate-200 py-3.5 px-4 flex justify-around items-center shrink-0 shadow-[0_-5px_20px_-3px_rgba(0,0,0,0.05)] z-10">
          {[
            { label: "Dashboard", icon: LayoutDashboard },
            { label: "Rooms", icon: Building2 },
            { label: "Payments", icon: CreditCard },
            { label: "Reports", icon: TrendingUp },
            { label: "Settings", icon: SettingsIcon }
          ].map((tab) => {
            const Icon = tab.icon;
            const isSelected = activeTab === tab.label;
            return (
              <button
                key={tab.label}
                onClick={() => setActiveTab(tab.label)}
                className="flex flex-col items-center gap-1 cursor-pointer transition-all focus:outline-none relative group"
              >
                <div
                  className={`px-5 py-1.5 rounded-2xl flex items-center justify-center transition-all ${
                    isSelected ? "bg-orange-50 text-orange-600 shadow-sm border border-orange-100" : "text-slate-400 hover:text-orange-500 hover:bg-slate-50"
                  }`}
                >
                  <Icon className="w-5 h-5" />
                </div>
                <span className={`text-[10px] font-bold uppercase tracking-wider ${isSelected ? "text-orange-600 font-extrabold" : "text-slate-400 group-hover:text-orange-500"}`}>
                  {tab.label}
                </span>
              </button>
            );
          })}
        </div>
      </div>
    );
  }

  // --- TAB: DASHBOARD ---
  function _renderDashboard() {
    return (
      <div className="space-y-6 text-left animate-fade-in" id="dashboard_tab">
        {/* Vedic Saffron Welcome Header Banner */}
        <div className="bg-orange-600 text-white p-6 md:p-8 rounded-3xl shadow-lg relative overflow-hidden" id="welcome_banner_card">
          <div className="relative z-10 space-y-2">
            <span className="text-[10px] font-black tracking-widest bg-orange-700/60 px-3 py-1 rounded-full uppercase">
              जय श्री राम &bull; Owner View
            </span>
            <h3 className="text-xl md:text-2xl font-black tracking-tight pt-1">Welcome, {ownerName}</h3>
            <div className="flex items-baseline gap-2 mt-2">
              <span className="text-4xl md:text-5xl font-black">{occupiedRoomsCount}</span>
              <span className="text-base opacity-90 font-bold">/ {totalRoomsCount} Rooms Occupied</span>
            </div>
            <p className="text-xs md:text-sm opacity-90 font-medium italic">
              {vacantRoomsCount} Vacant Rooms Available in {buildingName}
            </p>
          </div>
          <div className="absolute -right-8 -bottom-8 w-40 h-40 bg-orange-500 rounded-full opacity-50 z-0" />
        </div>

        {/* Occupancy Mini Cards */}
        <div className="grid grid-cols-2 gap-4">
          <div className="bg-white p-5 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-3.5" id="card_occupied_stats">
            <div className="bg-orange-50 w-11 h-11 rounded-2xl text-orange-600 shrink-0 flex items-center justify-center">
              <Check className="w-5 h-5" />
            </div>
            <div>
              <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Occupied</p>
              <h4 className="text-xl font-extrabold text-slate-800 leading-none mt-1">{occupiedRoomsCount}</h4>
              <p className="text-[9px] text-slate-400 mt-1">Active rooms</p>
            </div>
          </div>

          <div className="bg-white p-5 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-3.5" id="card_vacant_stats">
            <div className="bg-emerald-50 w-11 h-11 rounded-2xl text-emerald-600 shrink-0 flex items-center justify-center">
              <Users className="w-5 h-5" />
            </div>
            <div>
              <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Vacant</p>
              <h4 className="text-xl font-extrabold text-slate-800 leading-none mt-1">{vacantRoomsCount}</h4>
              <p className="text-[9px] text-slate-400 mt-1">Ready to lease</p>
            </div>
          </div>
        </div>

        {/* Section title */}
        <div className="flex justify-between items-center px-1">
          <h4 className="text-xs font-extrabold text-slate-500 tracking-widest uppercase">
            Rent & Cashflow
          </h4>
        </div>

        {/* Financial Stat cards */}
        <div className="grid grid-cols-2 gap-4">
          <div className="bg-white p-5 rounded-3xl border border-slate-100 shadow-sm flex flex-col justify-between min-h-[130px]" id="card_total_expected">
            <div className="text-slate-500 text-xs font-bold uppercase mb-2">Total Expected</div>
            <div className="text-2xl font-black text-slate-800">₹{totalExpectedRent.toLocaleString()}</div>
            <div className="mt-4 w-full bg-slate-100 h-1.5 rounded-full overflow-hidden">
              <div className="bg-orange-500 h-1.5 rounded-full" style={{ width: "100%" }}></div>
            </div>
          </div>

          <div className="bg-white p-5 rounded-3xl border border-slate-100 shadow-sm flex flex-col justify-between min-h-[130px]" id="card_rent_collected">
            <div className="text-green-600 text-xs font-bold uppercase mb-2">Rent Collected</div>
            <div className="text-2xl font-black text-slate-800">₹{totalRentCollected.toLocaleString()}</div>
            <div className="mt-4 w-full bg-slate-100 h-1.5 rounded-full overflow-hidden">
              <div
                className="bg-green-500 h-1.5 rounded-full"
                style={{ width: `${totalExpectedRent > 0 ? (totalRentCollected / totalExpectedRent) * 100 : 100}%` }}
              ></div>
            </div>
          </div>
        </div>

        {/* Outstandings indicator panel */}
        <div className="bg-white p-5 rounded-3xl border border-slate-100 shadow-sm flex flex-col justify-between min-h-[130px]" id="card_pending_rent">
          <div>
            <div className="text-red-500 text-xs font-bold uppercase mb-2 flex justify-between items-center">
              <span>Pending Rent</span>
              <AlertTriangle className="w-4 h-4 text-red-500" />
            </div>
            <div className="text-2xl font-black text-slate-800">₹{totalPendingRent.toLocaleString()}</div>
          </div>
          <div className="mt-4">
            <div className="w-full bg-slate-100 h-1.5 rounded-full overflow-hidden">
              <div
                className="bg-red-400 h-1.5 rounded-full"
                style={{ width: `${totalExpectedRent > 0 ? (totalPendingRent / totalExpectedRent) * 100 : 0}%` }}
              ></div>
            </div>
            <div className="flex justify-between text-[9px] text-slate-400 font-bold mt-2 uppercase tracking-wider">
              <span>Collected: {totalExpectedRent > 0 ? ((totalRentCollected / totalExpectedRent) * 100).toFixed(0) : 100}%</span>
              <span>Pending: {totalExpectedRent > 0 ? ((totalPendingRent / totalExpectedRent) * 100).toFixed(0) : 0}%</span>
            </div>
          </div>
        </div>

        {/* Electricity Section title */}
        <div className="flex justify-between items-center px-1 pt-2">
          <h4 className="text-xs font-extrabold text-slate-500 tracking-widest uppercase">
            Electricity metrics
          </h4>
        </div>

        {/* Electricity Row card */}
        <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center justify-between" id="electricity_row_card">
          <div className="flex gap-4 items-center text-left">
            <div className="w-12 h-12 bg-yellow-50 rounded-2xl flex items-center justify-center shrink-0">
              <Bolt className="h-6 w-6 text-yellow-600" />
            </div>
            <div>
              <div className="text-slate-500 text-xs font-bold uppercase">Electricity Collection</div>
              <div className="text-xl font-bold text-slate-800 mt-0.5">
                ₹{totalElectricityCollected.toLocaleString()} <span className="text-xs text-green-600 font-semibold bg-green-50 px-2 py-0.5 rounded-full ml-1.5">Collected</span>
              </div>
            </div>
          </div>
          <div className="text-right">
            <div className="text-slate-400 text-xs font-bold uppercase">Pending</div>
            <div className="text-lg font-bold text-orange-600 mt-0.5">₹{totalPendingElectricity.toLocaleString()}</div>
          </div>
        </div>

        {/* Recent Transactions List */}
        <div className="space-y-3">
          <div className="flex justify-between items-center">
            <h4 className="text-xs font-bold text-slate-500 tracking-wider uppercase pl-1">
              Recent Payments Log
            </h4>
            <button
              onClick={() => setActiveTab("Payments")}
              className="text-xs font-bold text-orange-600 hover:underline cursor-pointer"
            >
              View All
            </button>
          </div>

          <div className="space-y-2.5">
            {payments.slice(0, 4).map((p) => (
              <div
                key={p.id}
                className="bg-white px-5 py-4 rounded-2xl border border-slate-100 shadow-sm flex justify-between items-center transition-all hover:bg-slate-50/60 text-left"
                id={`recent_pay_item_${p.id}`}
              >
                <div className="flex items-center gap-3.5">
                  <div className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 ${p.paymentMode === "UPI" ? "bg-orange-50 text-orange-600" : "bg-green-50 text-green-700"}`}>
                    {p.paymentMode === "UPI" ? <QrCode className="w-5 h-5" /> : <CreditCard className="w-5 h-5" />}
                  </div>
                  <div>
                    <h5 className="font-bold text-slate-800 text-sm leading-tight">Room {p.roomNumber}</h5>
                    <p className="text-xs text-slate-400 mt-1">{p.tenantName} &bull; {p.date}</p>
                  </div>
                </div>

                <div className="text-right">
                  <span className="font-bold text-sm text-green-600">
                    +₹{p.amountPaid.toLocaleString()}
                  </span>
                  <p className="text-[9px] text-slate-400 uppercase font-mono font-bold mt-1 tracking-wider">{p.paymentMode}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    );
  }

  // --- TAB: ROOMS GRID ---
  function _renderRooms() {
    // Rooms list filtered
    const filtered = rooms.filter((r) => {
      if (filterRoomStatus === "All") return true;
      if (filterRoomStatus === "Occupied") return r.isOccupied;
      if (filterRoomStatus === "Vacant") return !r.isOccupied;
      if (filterRoomStatus === "Pending") return r.pendingRent > 0 || r.pendingElectricity > 0;
      return true;
    });

    // Group rooms by floors
    const floorsMap: { [key: number]: Room[] } = {};
    filtered.forEach((r) => {
      if (!floorsMap[r.floor]) floorsMap[r.floor] = [];
      floorsMap[r.floor].push(r);
    });

    const floorNumbers = Object.keys(floorsMap).map(Number).sort((a, b) => b - a); // Higher floor on top

    return (
      <div className="space-y-6 text-left animate-fade-in" id="rooms_tab">
        {/* Room grid filter chips */}
        <div className="flex items-center gap-2 overflow-x-auto py-1">
          {[
            { label: "All", icon: Layers },
            { label: "Occupied", icon: CheckCircle2 },
            { label: "Vacant", icon: Users },
            { label: "Pending", icon: AlertTriangle }
          ].map((item) => {
            const Icon = item.icon;
            const isSelected = filterRoomStatus === item.label;
            return (
              <button
                key={item.label}
                onClick={() => setFilterRoomStatus(item.label as any)}
                className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-1.5 shrink-0 transition-all cursor-pointer ${
                  isSelected ? "bg-orange-600 text-white shadow-md shadow-orange-600/10" : "bg-white text-slate-600 border border-slate-100 hover:bg-slate-50"
                }`}
              >
                <Icon className="w-4 h-4" />
                {item.label}
              </button>
            );
          })}
        </div>

        {/* List of rooms floor by floor */}
        {floorNumbers.length === 0 ? (
          <div className="bg-white rounded-3xl p-8 border border-slate-100 shadow-sm text-center text-slate-400">
            <Building2 className="w-12 h-12 mx-auto text-slate-300 mb-2" />
            <p className="text-sm">No rooms match the active filter.</p>
          </div>
        ) : (
          floorNumbers.map((floorNum) => (
            <div key={floorNum} className="space-y-3">
              <div className="flex items-center gap-2 pl-1.5">
                <Layers className="w-4 h-4 text-orange-600" />
                <h4 className="text-xs font-bold text-slate-500 uppercase tracking-widest">
                  {floorNum === 1 ? "Ground Floor" : floorNum === 2 ? "First Floor" : floorNum === 3 ? "Second Floor" : "Third Floor"}
                </h4>
              </div>

              <div className="grid grid-cols-3 gap-3">
                {floorsMap[floorNum].map((room) => {
                  const hasDues = room.pendingRent > 0 || room.pendingElectricity > 0;
                  return (
                    <button
                      key={room.roomNumber}
                      onClick={() => {
                        setSelectedRoom(room);
                        setShowRoomDetails(true);
                      }}
                      className={`relative p-4 rounded-2xl border text-left flex flex-col justify-between aspect-[1.05] transition-all hover:scale-[1.03] cursor-pointer shadow-sm ${
                        room.isOccupied
                          ? hasDues
                            ? "bg-white border-red-200"
                            : "bg-white border-orange-200"
                          : "bg-slate-100/70 border-slate-200/80"
                      }`}
                      id={`room_grid_item_${room.roomNumber}`}
                    >
                      {/* Room Number & status dot */}
                      <div className="flex justify-between items-center w-full">
                        <span className="font-black text-lg text-slate-800 leading-none">
                          {room.roomNumber}
                        </span>
                        <div
                          className={`w-2.5 h-2.5 rounded-full ${
                            room.isOccupied ? (hasDues ? "bg-red-500 animate-pulse" : "bg-orange-500") : "bg-green-500"
                          }`}
                        />
                      </div>

                      {/* Room Occupant Name or state */}
                      <span className="text-xs font-bold text-slate-700 mt-2 block truncate">
                        {room.isOccupied ? room.currentTenantName?.split(" ")[0] : "Vacant"}
                      </span>

                      {/* Rent or billing dues badge */}
                      <div className="flex justify-between items-center w-full mt-1.5">
                        <span className="text-[10px] text-slate-400 font-bold font-mono">
                          ₹{(room.baseRentAmount / 1000).toFixed(1)}k
                        </span>
                        {room.isOccupied && hasDues ? (
                          <span className="text-[9px] bg-red-50 text-red-600 px-2 py-0.5 rounded-full font-black uppercase tracking-wider">
                            Dues
                          </span>
                        ) : room.isOccupied ? (
                          <span className="text-[9px] bg-green-50 text-green-700 px-2 py-0.5 rounded-full font-black uppercase tracking-wider">
                            Paid
                          </span>
                        ) : null}
                      </div>
                    </button>
                  );
                })}
              </div>
            </div>
          ))
        )}
      </div>
    );
  }

  // --- TAB: PAYMENTS LOGGER & HISTORY ---
  function _renderPayments() {
    return (
      <div className="space-y-6 text-left animate-fade-in" id="payments_tab">
        {/* Top billing quick actions */}
        <div className="grid grid-cols-2 gap-4">
          <button
            onClick={() => {
              const occupied = rooms.filter((r) => r.isOccupied);
              if (occupied.length > 0) {
                setPaymentForm({
                  roomNumber: occupied[0].roomNumber,
                  rentPaid: occupied[0].pendingRent,
                  elecPaid: occupied[0].pendingElectricity,
                  mode: "UPI"
                });
                setShowRecordPaymentModal(true);
              }
            }}
            className="bg-orange-600 hover:bg-orange-700 text-white p-4 rounded-2xl flex items-center justify-center gap-2 text-xs font-bold transition-all shadow-md shadow-orange-600/10 cursor-pointer"
          >
            <Plus className="w-4 h-4" />
            Record Payment
          </button>

          <button
            onClick={() => {
              const occupied = rooms.filter((r) => r.isOccupied);
              if (occupied.length > 0) {
                setQrAmount(occupied[0].pendingRent + occupied[0].pendingElectricity || occupied[0].baseRentAmount);
                setShowQrModal(true);
              }
            }}
            className="bg-emerald-600 hover:bg-emerald-700 text-white p-4 rounded-2xl flex items-center justify-center gap-2 text-xs font-bold transition-all shadow-md shadow-emerald-600/10 cursor-pointer"
          >
            <QrCode className="w-4 h-4" />
            Generate UPI QR
          </button>
        </div>

        {/* Transactions log list */}
        <div className="space-y-3">
          <div className="flex justify-between items-center px-1">
            <h4 className="text-xs font-bold text-slate-500 tracking-wider uppercase">
              Financial ledger history
            </h4>
          </div>

          <div className="space-y-3">
            {payments.map((p) => (
              <div key={p.id} className="bg-white p-6 rounded-3xl border border-slate-100 space-y-4 shadow-sm" id={`payment_item_${p.id}`}>
                <div className="flex justify-between items-center">
                  <div className="flex items-center gap-3.5 text-left">
                    <div className="bg-orange-50 w-11 h-11 rounded-2xl text-orange-600 shrink-0 flex items-center justify-center">
                      <Building2 className="w-5 h-5" />
                    </div>
                    <div>
                      <h5 className="font-extrabold text-slate-800 text-sm leading-tight">Room {p.roomNumber}</h5>
                      <p className="text-xs text-slate-400 font-bold mt-1 uppercase tracking-wide">{p.tenantName}</p>
                    </div>
                  </div>

                  <div className="text-right">
                    <span className="font-black text-lg text-green-600">
                      +₹{p.amountPaid.toLocaleString()}
                    </span>
                    <span className="block text-[10px] font-bold text-slate-400 uppercase tracking-widest mt-1">
                      {p.paymentMode}
                    </span>
                  </div>
                </div>

                <div className="border-t border-slate-100 pt-3 flex justify-between items-center text-xs text-slate-400 font-bold">
                  <span>Date: {p.date}</span>
                  <div className="flex gap-3">
                    <span className="bg-slate-50 px-2.5 py-1 rounded-lg">Rent: ₹{p.rentComponent}</span>
                    <span className="bg-slate-50 px-2.5 py-1 rounded-lg">Elec: ₹{p.electricityComponent}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    );
  }

  // --- TAB: REPORTS & STATEMENTS ---
  function _renderReports() {
    return (
      <div className="space-y-6 text-left animate-fade-in" id="reports_tab">
        {/* Occupancy gauge */}
        <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex flex-col items-center justify-center space-y-5 text-center">
          <h4 className="font-bold text-slate-800 text-sm uppercase tracking-wider">Occupancy Ratio Analytics</h4>
          
          <div className="relative w-36 h-36 flex items-center justify-center">
            {/* simple custom SVG circular dial */}
            <svg className="w-full h-full transform -rotate-90">
              <circle cx="72" cy="72" r="58" fill="transparent" stroke="#f1f5f9" strokeWidth="12" />
              <circle
                cx="72"
                cy="72"
                r="58"
                fill="transparent"
                stroke="#16a34a"
                strokeWidth="12"
                strokeDasharray="364.4"
                strokeDashoffset={364.4 - (364.4 * (occupiedRoomsCount / totalRoomsCount))}
                strokeLinecap="round"
              />
            </svg>
            <div className="absolute flex flex-col items-center">
              <span className="text-3xl font-black text-slate-800">
                {((occupiedRoomsCount / totalRoomsCount) * 100).toFixed(0)}%
              </span>
              <span className="text-[10px] text-slate-400 font-bold uppercase tracking-wider mt-1">
                Occupied
              </span>
            </div>
          </div>

          <div className="flex gap-5 text-xs font-bold text-slate-600">
            <span className="flex items-center gap-1.5"><div className="w-2.5 h-2.5 rounded-full bg-emerald-600" /> {occupiedRoomsCount} Active Leases</span>
            <span className="flex items-center gap-1.5"><div className="w-2.5 h-2.5 rounded-full bg-slate-200" /> {vacantRoomsCount} Vacant Rooms</span>
          </div>
        </div>

        {/* Cashflow breakdown line progress bar */}
        <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm space-y-4">
          <h4 className="font-bold text-slate-800 text-sm uppercase tracking-wider">Cashflow collection progress</h4>

          <div className="space-y-4">
            <div>
              <div className="flex justify-between text-xs font-bold text-slate-600 mb-1.5">
                <span>Rent Collections</span>
                <span>₹{totalRentCollected.toLocaleString()} / ₹{totalExpectedRent.toLocaleString()}</span>
              </div>
              <div className="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                <div
                  className="bg-emerald-600 h-full transition-all duration-500"
                  style={{ width: `${totalExpectedRent > 0 ? (totalRentCollected / totalExpectedRent) * 100 : 100}%` }}
                />
              </div>
            </div>

            <div>
              <div className="flex justify-between text-xs font-bold text-slate-600 mb-1.5">
                <span>Electricity Collections</span>
                <span>₹{totalElectricityCollected.toLocaleString()} / ₹{(totalElectricityCollected + totalPendingElectricity).toLocaleString()}</span>
              </div>
              <div className="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
                <div
                  className="bg-amber-500 h-full transition-all duration-500"
                  style={{ width: `${(totalElectricityCollected + totalPendingElectricity) > 0 ? (totalElectricityCollected / (totalElectricityCollected + totalPendingElectricity)) * 100 : 100}%` }}
                />
              </div>
            </div>
          </div>
        </div>

        {/* Generate sheet invoice card (Green yield card layout) */}
        <div className="bg-green-700 text-white p-6 rounded-3xl shadow-md flex flex-col justify-between gap-5 text-left relative overflow-hidden" id="green_report_yield_card">
          <div className="relative z-10">
            <div className="flex justify-between items-start mb-4">
              <div className="w-10 h-10 bg-green-600 rounded-xl flex items-center justify-center shadow-inner">
                <FileText className="w-5 h-5 text-white" />
              </div>
              <div className="text-right">
                <div className="text-[10px] opacity-70 font-bold uppercase tracking-widest">Quick Report</div>
                <div className="text-sm font-semibold">Monthly Yield</div>
              </div>
            </div>
            <h4 className="font-extrabold text-white text-base mt-2">Monthly Reconciliation Report</h4>
            <p className="text-xs opacity-80 mt-1">
              Generate a structured ledger billing invoice of all collections, dues and readings for June 2026.
            </p>
          </div>
          <button
            onClick={() => setShowReportPreviewModal(true)}
            className="w-full bg-white text-green-700 py-3 rounded-xl font-bold text-sm shadow-sm hover:bg-slate-50 transition-all cursor-pointer relative z-10"
          >
            Build Reconciliation Statement
          </button>
          <div className="absolute -right-8 -bottom-8 w-32 h-32 bg-green-600 rounded-full opacity-30 z-0" />
        </div>
      </div>
    );
  }

  // --- TAB: SETTINGS PANEL ---
  function _renderSettings() {
    return (
      <div className="space-y-6 text-left animate-fade-in" id="settings_tab">
        {/* Building profile details card */}
        <div className="bg-white p-6 rounded-3xl border border-slate-100 flex items-center gap-4 shadow-sm" id="profile_details_card">
          <div className="bg-orange-100 p-3.5 rounded-2xl text-orange-600 shrink-0">
            <Building2 className="w-7 h-7" />
          </div>
          <div className="text-left">
            <h4 className="font-extrabold text-lg text-slate-800 leading-tight">{buildingName}</h4>
            <p className="text-xs text-slate-500 font-bold mt-1">Proprietor: {ownerName}</p>
            <p className="text-[10px] text-orange-600 font-extrabold uppercase mt-2 tracking-wider bg-orange-50 px-2 py-0.5 rounded-full w-fit">Active Ledger: 36 Rooms</p>
          </div>
        </div>

        {/* Configurations input box */}
        <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm space-y-5" id="config_inputs_card">
          <h4 className="font-bold text-slate-800 text-sm border-b border-slate-100 pb-2.5 flex items-center gap-2 uppercase tracking-wider">
            <SettingsIcon className="w-4 h-4 text-orange-600" />
            Property parameters
          </h4>

          <div className="space-y-4 text-xs">
            <div className="space-y-1.5 text-left">
              <label className="font-extrabold text-slate-500 uppercase tracking-wide">Residency / Building Name</label>
              <input
                type="text"
                value={buildingName}
                onChange={(e) => setBuildingName(e.target.value)}
                className="w-full px-4 py-3 border border-slate-200 rounded-xl text-slate-800 focus:outline-none focus:ring-2 focus:ring-orange-500 font-bold text-sm"
              />
            </div>

            <div className="space-y-1.5 text-left">
              <label className="font-extrabold text-slate-500 uppercase tracking-wide">Proprietor Full Name</label>
              <input
                type="text"
                value={ownerName}
                onChange={(e) => setOwnerName(e.target.value)}
                className="w-full px-4 py-3 border border-slate-200 rounded-xl text-slate-800 focus:outline-none focus:ring-2 focus:ring-orange-500 font-bold text-sm"
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-1.5 text-left">
                <label className="font-extrabold text-slate-500 uppercase tracking-wide">Electricity (₹/kWh)</label>
                <input
                  type="number"
                  value={electricityRate}
                  onChange={(e) => setElectricityRate(Number(e.target.value))}
                  className="w-full px-4 py-3 border border-slate-200 rounded-xl text-slate-800 focus:outline-none focus:ring-2 focus:ring-orange-500 font-mono font-bold text-sm"
                />
              </div>

              <div className="space-y-1.5 text-left">
                <label className="font-extrabold text-slate-500 uppercase tracking-wide">UPI ID for Payments</label>
                <input
                  type="text"
                  value={upiId}
                  onChange={(e) => setUpiId(e.target.value)}
                  className="w-full px-4 py-3 border border-slate-200 rounded-xl text-slate-800 focus:outline-none focus:ring-2 focus:ring-orange-500 font-mono font-bold text-sm"
                />
              </div>
            </div>
          </div>
        </div>

        {/* Operations card */}
        <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm space-y-4" id="ledger_operations_card">
          <h4 className="font-bold text-slate-800 text-sm border-b border-slate-100 pb-2.5 uppercase tracking-wider text-left">
            Ledger operations
          </h4>
          <button
            onClick={() => alert("Local backup saved in localstorage! To export Flutter code, use the file tabs on the right side.")}
            className="w-full border border-orange-500 hover:bg-orange-50 text-orange-600 py-3 rounded-xl text-xs font-bold flex items-center justify-center gap-2 transition-all cursor-pointer shadow-sm"
          >
            <Download className="w-4 h-4" />
            Backup Database Ledger
          </button>
        </div>
      </div>
    );
  }

  // --- SUB-VIEW: TENANTS REGISTER ---
  function _renderTenantsList() {
    const activeTenants = tenants.filter((t) => {
      const matchesSearch = t.name.toLowerCase().includes(tenantSearchQuery.toLowerCase()) || t.roomNumber.includes(tenantSearchQuery);
      return t.isActive && matchesSearch;
    });

    return (
      <div className="space-y-6 text-left animate-fade-in" id="tenants_list_subview">
        {/* Search bar */}
        <div className="bg-white px-5 py-3 rounded-2xl border border-slate-100 flex items-center gap-3 shadow-sm">
          <Search className="w-4 h-4 text-slate-400 shrink-0" />
          <input
            type="text"
            placeholder="Search active tenant by name or room..."
            value={tenantSearchQuery}
            onChange={(e) => setTenantSearchQuery(e.target.value)}
            className="w-full text-xs text-slate-800 focus:outline-none bg-transparent font-medium"
          />
        </div>

        <div className="space-y-4">
          {activeTenants.length === 0 ? (
            <div className="bg-white rounded-3xl p-8 border border-slate-100 shadow-sm text-center text-slate-400 text-sm">
              No tenants match search query.
            </div>
          ) : (
            activeTenants.map((t) => {
              const r = rooms.find((room) => room.roomNumber === t.roomNumber);
              return (
                <div key={t.id} className="bg-white p-6 rounded-3xl border border-slate-100 space-y-4 shadow-sm text-left">
                  <div className="flex justify-between items-center">
                    <div className="flex items-center gap-3.5">
                      <div className="bg-emerald-50 text-emerald-600 w-11 h-11 rounded-2xl shrink-0 flex items-center justify-center">
                        <Users className="w-5 h-5" />
                      </div>
                      <div>
                        <h5 className="font-extrabold text-slate-800 text-sm">{t.name}</h5>
                        <p className="text-xs text-slate-400 font-bold mt-1">{t.phone}</p>
                      </div>
                    </div>

                    <span className="bg-orange-50 text-orange-600 font-extrabold text-xs px-3 py-1 rounded-full border border-orange-100 shadow-sm">
                      Room {t.roomNumber}
                    </span>
                  </div>

                  <div className="border-t border-slate-100 pt-4 flex justify-between text-xs text-slate-500 font-bold uppercase tracking-wider">
                    <div>
                      <span className="text-[10px] text-slate-400 block font-normal normal-case mb-1">Agreement date</span>
                      <span>{t.joinDate}</span>
                    </div>
                    <div>
                      <span className="text-[10px] text-slate-400 block font-normal normal-case mb-1">Deposit paid</span>
                      <span className="text-blue-600">₹{t.securityDeposit.toLocaleString()}</span>
                    </div>
                    <div>
                      <span className="text-[10px] text-slate-400 block font-normal normal-case mb-1">Base Rent</span>
                      <span>₹{r?.baseRentAmount.toLocaleString() || "8,000"}</span>
                    </div>
                  </div>

                  <div className="flex justify-end gap-2.5 pt-2">
                    <a
                      href={`tel:${t.phone}`}
                      className="text-xs bg-slate-50 hover:bg-slate-100 text-slate-600 border border-slate-200 font-bold px-4 py-2 rounded-xl flex items-center gap-1.5 cursor-pointer transition-colors"
                    >
                      <Phone className="w-4 h-4 text-slate-400" />
                      Dial
                    </a>
                    <button
                      onClick={() => {
                        setQrAmount(r?.baseRentAmount || 8000);
                        setShowQrModal(true);
                      }}
                      className="text-xs bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-200 font-bold px-4 py-2 rounded-xl flex items-center gap-1.5 cursor-pointer transition-colors"
                    >
                      <QrCode className="w-4 h-4 text-emerald-500" />
                      Collect UPI
                    </button>
                  </div>
                </div>
              );
            })
          )}
        </div>
      </div>
    );
  }

  // --- SUB-VIEW: ELECTRICITY LEDGER ---
  function _renderElectricityLedger() {
    const occupied = rooms.filter((r) => r.isOccupied);

    return (
      <div className="space-y-6 text-left animate-fade-in" id="electricity_subview">
        <div className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center justify-between">
          <div className="space-y-1 text-left">
            <h4 className="font-extrabold text-slate-800 text-sm uppercase tracking-wider">Tariff Parameter</h4>
            <p className="text-xs text-slate-500 font-bold">Currently billing at ₹{electricityRate}/unit</p>
          </div>
          <span className="bg-amber-50 text-amber-600 border border-amber-100 text-[10px] font-black uppercase tracking-wider px-3 py-1.5 rounded-full shadow-sm">
            Active Mode
          </span>
        </div>

        <div className="space-y-4">
          {occupied.map((r) => (
            <div key={r.roomNumber} className="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm space-y-4 text-left" id={`electricity_room_item_${r.roomNumber}`}>
              <div className="flex justify-between items-center">
                <div>
                  <h5 className="font-extrabold text-slate-800 text-base leading-tight">Room {r.roomNumber}</h5>
                  <p className="text-xs text-slate-400 font-bold mt-1 uppercase tracking-wide">{r.currentTenantName}</p>
                </div>
                <button
                  onClick={() => {
                    setMeterForm({ roomNumber: r.roomNumber, currentReading: r.lastMeterReading + 40 });
                    setShowLogMeterModal(true);
                  }}
                  className="bg-orange-600 hover:bg-orange-700 text-white text-xs font-bold px-4 py-2 rounded-xl flex items-center gap-1.5 shadow-md shadow-orange-600/10 transition-all cursor-pointer"
                >
                  <Plus className="w-4 h-4" />
                  Log Reading
                </button>
              </div>

              <div className="border-t border-slate-100 pt-4 flex justify-between items-center text-xs font-bold text-slate-600 uppercase tracking-wider">
                <div>
                  <span className="text-[10px] text-slate-400 block font-normal normal-case mb-1">Last Index</span>
                  <span>{r.lastMeterReading} kWh</span>
                </div>
                <div>
                  <span className="text-[10px] text-slate-400 block font-normal normal-case mb-1">Dues Calculated</span>
                  <span className="text-amber-600">₹{r.pendingElectricity.toLocaleString()}</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  }

  // ==========================================
  // --- FLUTTER-STYLE DIALOGS & OVERLAYS ---
  // ==========================================

  function _renderActiveModals() {
    return (
      <>
        {/* ROOM DETAILED CONTROL SHEET */}
        {showRoomDetails && selectedRoom && (
          <div className="absolute inset-0 bg-black/60 z-50 flex items-end justify-center" id="room_bottom_sheet">
            {/* Click outside to close */}
            <div className="absolute inset-0" onClick={() => setShowRoomDetails(false)} />

            {/* Bottom Sheet Box */}
            <div className="bg-white w-full max-w-md rounded-t-[32px] p-6 text-slate-800 z-10 shadow-2xl relative animate-slide-up text-left max-h-[85%] overflow-y-auto">
              {/* Notch handle */}
              <div className="w-12 h-1.5 bg-slate-200 rounded-full mx-auto mb-6" />

              <div className="flex justify-between items-center mb-4">
                <h3 className="text-lg font-black text-slate-800">
                  Room {selectedRoom.roomNumber} Controls
                </h3>
                <span
                  className={`px-3 py-1 rounded-full text-xs font-extrabold ${
                    selectedRoom.isOccupied ? "bg-orange-100 text-orange-700" : "bg-emerald-100 text-emerald-700"
                  }`}
                >
                  {selectedRoom.isOccupied ? "Occupied" : "Vacant"}
                </span>
              </div>

              <div className="grid grid-cols-2 gap-4 bg-slate-50 p-4 rounded-2xl border border-slate-100 mb-5 text-xs">
                <div>
                  <span className="text-slate-400 block font-medium uppercase tracking-wider text-[9px]">Base Rental Rent</span>
                  <span className="font-bold text-slate-700 text-sm">₹{selectedRoom.baseRentAmount.toLocaleString()}</span>
                </div>
                <div>
                  <span className="text-slate-400 block font-medium uppercase tracking-wider text-[9px]">Last Meter reading</span>
                  <span className="font-bold text-slate-700 text-sm">{selectedRoom.lastMeterReading} kWh</span>
                </div>
              </div>

              {selectedRoom.isOccupied ? (
                /* --- IF ROOM OCCUPIED --- */
                <div className="space-y-4">
                  {/* Tenant Profile Container */}
                  <div className="bg-slate-50 p-4 rounded-2xl border border-slate-200/50 space-y-3 text-xs">
                    <span className="text-emerald-700 font-extrabold block text-[10px] tracking-wider uppercase">
                      Current resident info
                    </span>
                    <div className="flex justify-between">
                      <span className="font-bold text-sm text-slate-800">{selectedRoom.currentTenantName}</span>
                      <span className="text-slate-500 font-mono">
                        {tenants.find((t) => t.roomNumber === selectedRoom.roomNumber && t.isActive)?.phone}
                      </span>
                    </div>

                    <div className="grid grid-cols-2 gap-2 pt-2 border-t border-slate-200/40">
                      <div>
                        <span className="text-slate-400 block text-[9px] uppercase tracking-wider">Unpaid Rent</span>
                        <span className="font-extrabold text-red-600">₹{selectedRoom.pendingRent.toLocaleString()}</span>
                      </div>
                      <div>
                        <span className="text-slate-400 block text-[9px] uppercase tracking-wider">Meter Dues</span>
                        <span className="font-extrabold text-amber-600">₹{selectedRoom.pendingElectricity.toLocaleString()}</span>
                      </div>
                    </div>
                  </div>

                  {/* Operational actions */}
                  <div className="grid grid-cols-2 gap-2.5 pt-2">
                    <button
                      onClick={() => {
                        setPaymentForm({
                          roomNumber: selectedRoom.roomNumber,
                          rentPaid: selectedRoom.pendingRent,
                          elecPaid: selectedRoom.pendingElectricity,
                          mode: "UPI"
                        });
                        setShowRoomDetails(false);
                        setShowRecordPaymentModal(true);
                      }}
                      className="bg-orange-600 hover:bg-orange-700 text-white font-bold py-3.5 rounded-xl text-xs flex items-center justify-center gap-2 shadow-sm transition-all cursor-pointer"
                    >
                      <CreditCard className="w-4 h-4" />
                      Add Payment
                    </button>

                    <button
                      onClick={() => {
                        setMeterForm({
                          roomNumber: selectedRoom.roomNumber,
                          currentReading: selectedRoom.lastMeterReading + 40
                        });
                        setShowRoomDetails(false);
                        setShowLogMeterModal(true);
                      }}
                      className="border border-orange-500 text-orange-600 hover:bg-orange-50 font-bold py-3.5 rounded-xl text-xs flex items-center justify-center gap-2 transition-all cursor-pointer"
                    >
                      <Bolt className="w-4 h-4" />
                      Log Meter Index
                    </button>
                  </div>

                  {/* Evict checkout button */}
                  <button
                    onClick={() => {
                      if (confirm(`Do you want to process tenant checkout for Room ${selectedRoom.roomNumber}? This resets balances and sets occupancy status to Vacant.`)) {
                        handleCheckoutTenant(selectedRoom.roomNumber);
                      }
                    }}
                    className="w-full text-red-600 bg-red-50 hover:bg-red-100 py-3 rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 transition-colors cursor-pointer"
                  >
                    <LogOut className="w-4 h-4" />
                    Checkout Tenant (Vacate Room)
                  </button>
                </div>
              ) : (
                /* --- IF ROOM VACANT --- */
                <div className="space-y-4">
                  <div className="text-center py-6 text-slate-400">
                    <UserPlus className="w-12 h-12 mx-auto text-slate-300 mb-2" />
                    <p className="text-sm">This room is ready to lease immediately.</p>
                  </div>
                  <button
                    onClick={() => {
                      setCheckInForm({
                        roomNumber: selectedRoom.roomNumber,
                        tenantName: "",
                        phone: "",
                        deposit: selectedRoom.baseRentAmount * 2,
                        baseRent: selectedRoom.baseRentAmount
                      });
                      setShowRoomDetails(false);
                      setShowCheckInModal(true);
                    }}
                    className="w-full bg-orange-600 hover:bg-orange-700 text-white font-bold py-3.5 rounded-xl text-xs flex items-center justify-center gap-2 shadow-md transition-all cursor-pointer"
                  >
                    <UserPlus className="w-4 h-4" />
                    Check-in Onboard Tenant
                  </button>
                </div>
              )}
            </div>
          </div>
        )}

        {/* DIALOG: RECORD PAYMENT FORM */}
        {showRecordPaymentModal && (
          <div className="absolute inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-3xl p-6 w-full max-w-sm text-slate-800 shadow-2xl relative animate-scale-in text-left">
              <h3 className="text-lg font-black text-slate-800 mb-1">
                Record Payment
              </h3>
              <p className="text-xs text-slate-400 mb-4">Input actual cash collection logs</p>

              <div className="space-y-3 text-xs mb-5">
                <div className="grid grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <label className="font-bold text-slate-400">Room Number</label>
                    <input
                      type="text"
                      disabled
                      value={paymentForm.roomNumber}
                      className="w-full px-3 py-2 border border-slate-100 bg-slate-50 text-slate-800 rounded-lg font-bold"
                    />
                  </div>

                  <div className="space-y-1">
                    <label className="font-bold text-slate-400">Gateway Mode</label>
                    <select
                      value={paymentForm.mode}
                      onChange={(e) => setPaymentForm({ ...paymentForm, mode: e.target.value })}
                      className="w-full px-3 py-2 border border-slate-200 text-slate-800 rounded-lg focus:outline-none"
                    >
                      <option value="UPI">UPI Payment</option>
                      <option value="Cash">Cash Ledger</option>
                      <option value="Bank">Net Banking</option>
                    </select>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <label className="font-bold text-slate-400">Rent Paid (₹)</label>
                    <input
                      type="number"
                      value={paymentForm.rentPaid}
                      onChange={(e) => setPaymentForm({ ...paymentForm, rentPaid: Number(e.target.value) })}
                      className="w-full px-3 py-2 border border-slate-200 text-slate-800 rounded-lg focus:outline-none"
                    />
                  </div>

                  <div className="space-y-1">
                    <label className="font-bold text-slate-400">Electricity Paid (₹)</label>
                    <input
                      type="number"
                      value={paymentForm.elecPaid}
                      onChange={(e) => setPaymentForm({ ...paymentForm, elecPaid: Number(e.target.value) })}
                      className="w-full px-3 py-2 border border-slate-200 text-slate-800 rounded-lg focus:outline-none"
                    />
                  </div>
                </div>
              </div>

              <div className="flex gap-2">
                <button
                  onClick={() => setShowRecordPaymentModal(false)}
                  className="flex-1 border border-slate-200 text-slate-500 py-3 rounded-xl font-bold text-xs hover:bg-slate-50 cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  onClick={() => handleRecordPayment(paymentForm.roomNumber, paymentForm.rentPaid, paymentForm.elecPaid, paymentForm.mode)}
                  className="flex-1 bg-orange-600 hover:bg-orange-700 text-white py-3 rounded-xl font-bold text-xs shadow-sm cursor-pointer"
                >
                  Log Payment
                </button>
              </div>
            </div>
          </div>
        )}

        {/* DIALOG: LOG METER READING */}
        {showLogMeterModal && (
          <div className="absolute inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-3xl p-6 w-full max-w-sm text-slate-800 shadow-2xl relative animate-scale-in text-left">
              <h3 className="text-lg font-black text-slate-800 mb-1">
                Log Meter Reading
              </h3>
              <p className="text-xs text-slate-400 mb-4">Update monthly electricity units consumed</p>

              <div className="space-y-3 text-xs mb-5">
                <div className="flex gap-4 bg-slate-50 p-3 rounded-xl border border-slate-100 mb-2">
                  <div>
                    <span className="text-[10px] text-slate-400 font-bold uppercase">Prev Index</span>
                    <p className="font-extrabold text-sm text-slate-800">
                      {rooms.find((r) => r.roomNumber === meterForm.roomNumber)?.lastMeterReading} kWh
                    </p>
                  </div>
                  <div className="border-l border-slate-200 pl-4">
                    <span className="text-[10px] text-slate-400 font-bold uppercase">Estimated Units</span>
                    <p className="font-extrabold text-sm text-slate-800">
                      {Math.max(0, meterForm.currentReading - (rooms.find((r) => r.roomNumber === meterForm.roomNumber)?.lastMeterReading || 0))} Consumed
                    </p>
                  </div>
                </div>

                <div className="space-y-1">
                  <label className="font-bold text-slate-400">New Current Reading (kWh)</label>
                  <input
                    type="number"
                    value={meterForm.currentReading}
                    onChange={(e) => setMeterForm({ ...meterForm, currentReading: Number(e.target.value) })}
                    className="w-full px-3 py-2.5 border border-slate-200 text-slate-800 rounded-lg focus:outline-none font-mono text-sm"
                  />
                </div>
              </div>

              <div className="flex gap-2">
                <button
                  onClick={() => setShowLogMeterModal(false)}
                  className="flex-1 border border-slate-200 text-slate-500 py-3 rounded-xl font-bold text-xs hover:bg-slate-50 cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  onClick={() => handleLogElectricity(meterForm.roomNumber, meterForm.currentReading)}
                  className="flex-1 bg-orange-600 hover:bg-orange-700 text-white py-3 rounded-xl font-bold text-xs shadow-sm cursor-pointer"
                >
                  Calculate & Bill
                </button>
              </div>
            </div>
          </div>
        )}

        {/* DIALOG: CHECK-IN NEW TENANT */}
        {showCheckInModal && (
          <div className="absolute inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-3xl p-6 w-full max-w-sm text-slate-800 shadow-2xl relative animate-scale-in text-left max-h-[90%] overflow-y-auto">
              <h3 className="text-lg font-black text-slate-800 mb-1">
                New Tenant Check-in
              </h3>
              <p className="text-xs text-slate-400 mb-4">Onboard tenant for Room {checkInForm.roomNumber}</p>

              <div className="space-y-3 text-xs mb-5">
                <div className="space-y-1">
                  <label className="font-bold text-slate-400">Tenant Full Name</label>
                  <input
                    type="text"
                    placeholder="E.g. Sumit Rathore"
                    value={checkInForm.tenantName}
                    onChange={(e) => setCheckInForm({ ...checkInForm, tenantName: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 text-slate-800 rounded-lg focus:outline-none"
                  />
                </div>

                <div className="space-y-1">
                  <label className="font-bold text-slate-400">Mobile Phone</label>
                  <input
                    type="text"
                    placeholder="+91 XXXXX XXXXX"
                    value={checkInForm.phone}
                    onChange={(e) => setCheckInForm({ ...checkInForm, phone: e.target.value })}
                    className="w-full px-3 py-2 border border-slate-200 text-slate-800 rounded-lg focus:outline-none"
                  />
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <label className="font-bold text-slate-400">Monthly Rent (₹)</label>
                    <input
                      type="number"
                      value={checkInForm.baseRent}
                      onChange={(e) => setCheckInForm({ ...checkInForm, baseRent: Number(e.target.value) })}
                      className="w-full px-3 py-2 border border-slate-200 text-slate-800 rounded-lg focus:outline-none"
                    />
                  </div>

                  <div className="space-y-1">
                    <label className="font-bold text-slate-400">Deposit Paid (₹)</label>
                    <input
                      type="number"
                      value={checkInForm.deposit}
                      onChange={(e) => setCheckInForm({ ...checkInForm, deposit: Number(e.target.value) })}
                      className="w-full px-3 py-2 border border-slate-200 text-slate-800 rounded-lg focus:outline-none"
                    />
                  </div>
                </div>
              </div>

              <div className="flex gap-2">
                <button
                  onClick={() => setShowCheckInModal(false)}
                  className="flex-1 border border-slate-200 text-slate-500 py-3 rounded-xl font-bold text-xs hover:bg-slate-50 cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  onClick={() => handleAddTenant(checkInForm.roomNumber, checkInForm.tenantName, checkInForm.phone, checkInForm.deposit, checkInForm.baseRent)}
                  className="flex-1 bg-orange-600 hover:bg-orange-700 text-white py-3 rounded-xl font-bold text-xs shadow-sm cursor-pointer"
                >
                  Onboard
                </button>
              </div>
            </div>
          </div>
        )}

        {/* DIALOG: UPI QR CODE PRESENTATION */}
        {showQrModal && (
          <div className="absolute inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-3xl p-6 w-full max-w-sm text-slate-800 shadow-2xl relative animate-scale-in text-center">
              <h3 className="text-lg font-black text-slate-800 mb-1">
                Collect Rent Payment
              </h3>
              <p className="text-xs text-slate-400 mb-4">Direct UPI payment gateway</p>

              <div className="space-y-4 mb-5 flex flex-col items-center">
                <div className="w-full max-w-[180px] aspect-square border border-slate-200 p-2 rounded-2xl bg-white shadow-sm">
                  {/* Dynamic QrServer API for perfect vector representation */}
                  <img
                    src={`https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=${encodeURIComponent(
                      `upi://pay?pa=${upiId}&pn=Shree%20Ram%20Rooms&am=${qrAmount}&cu=INR&tn=Rent`
                    )}`}
                    alt="UPI QR Code"
                    className="w-full h-full object-contain"
                  />
                </div>

                <div>
                  <span className="text-[10px] text-slate-400 font-bold uppercase tracking-wider block">Collect Amount</span>
                  <p className="text-xl font-extrabold text-slate-800">
                    ₹{qrAmount.toLocaleString()}
                  </p>
                </div>

                <div className="text-[11px] text-slate-400 font-medium">
                  <p>UPI VPA: <span className="font-mono text-slate-600">{upiId}</span></p>
                  <p className="mt-1 font-bold text-emerald-600">Scan using BHIM, Paytm, PhonePe or GPay</p>
                </div>
              </div>

              <button
                onClick={() => setShowQrModal(false)}
                className="w-full bg-emerald-600 hover:bg-emerald-700 text-white py-3 rounded-xl font-bold text-xs shadow-sm cursor-pointer"
              >
                Finished Payment
              </button>
            </div>
          </div>
        )}

        {/* DIALOG: MONTHLY RECONCILIATION SUMMARY */}
        {showReportPreviewModal && (
          <div className="absolute inset-0 bg-black/60 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-3xl p-6 w-full max-w-md text-slate-800 shadow-2xl relative animate-scale-in text-left max-h-[90%] overflow-y-auto">
              <div className="flex justify-between items-start border-b border-slate-100 pb-3 mb-4">
                <div>
                  <h3 className="text-lg font-black text-slate-800">Reconciliation Statement</h3>
                  <p className="text-xs text-slate-400">June 2026 Audit Summary</p>
                </div>
                <div className="bg-emerald-50 text-emerald-800 text-[10px] font-black uppercase px-2.5 py-1 rounded">
                  Status: Balanced
                </div>
              </div>

              <div className="space-y-3.5 text-xs">
                <div className="border-b border-slate-100 pb-2">
                  <span className="text-[9px] text-slate-400 font-extrabold uppercase tracking-widest block">Residency details</span>
                  <span className="font-bold text-sm text-slate-700 block">{buildingName}</span>
                  <span className="text-slate-400 text-[11px]">Proprietor: {ownerName}</span>
                </div>

                <div className="grid grid-cols-2 gap-3 pb-2 border-b border-slate-100">
                  <div>
                    <span className="text-slate-400 text-[9px] uppercase tracking-wider block">Occupied Units</span>
                    <span className="font-bold text-slate-700 text-sm">{occupiedRoomsCount} / 36 Rooms</span>
                  </div>
                  <div>
                    <span className="text-slate-400 text-[9px] uppercase tracking-wider block">Leasing Capacity</span>
                    <span className="font-bold text-slate-700 text-sm">
                      {((occupiedRoomsCount / totalRoomsCount) * 100).toFixed(0)}% Occupancy
                    </span>
                  </div>
                </div>

                <div className="space-y-1.5 pb-2 border-b border-slate-100">
                  <span className="text-[9px] text-slate-400 font-extrabold uppercase tracking-widest block">Collection Parameters</span>
                  <div className="flex justify-between">
                    <span className="text-slate-500 font-medium">Saffron Rent Collected</span>
                    <span className="font-bold text-emerald-600">+₹{totalRentCollected.toLocaleString()}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-slate-500 font-medium">Electricity Collected</span>
                    <span className="font-bold text-emerald-600">+₹{totalElectricityCollected.toLocaleString()}</span>
                  </div>
                </div>

                <div className="space-y-1.5 pb-2">
                  <span className="text-[9px] text-slate-400 font-extrabold uppercase tracking-widest block font-bold">Pending accounts dues</span>
                  <div className="flex justify-between">
                    <span className="text-slate-500 font-medium">Outstanding Rent</span>
                    <span className="font-bold text-red-600">₹{totalPendingRent.toLocaleString()}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-slate-500 font-medium">Outstanding Meter Bill</span>
                    <span className="font-bold text-red-600">₹{totalPendingElectricity.toLocaleString()}</span>
                  </div>
                </div>
              </div>

              <div className="flex gap-2 mt-6">
                <button
                  onClick={() => setShowReportPreviewModal(false)}
                  className="flex-1 border border-slate-200 text-slate-500 py-3.5 rounded-xl font-bold text-xs hover:bg-slate-50 cursor-pointer"
                >
                  Close
                </button>
                <button
                  onClick={() => {
                    alert("Exporting Monthly Reconciliation Invoice PDF...");
                    setShowReportPreviewModal(false);
                  }}
                  className="flex-1 bg-emerald-700 hover:bg-emerald-800 text-white py-3.5 rounded-xl font-bold text-xs flex items-center justify-center gap-1.5 shadow-sm cursor-pointer"
                >
                  <Download className="w-4 h-4" />
                  Save PDF Statement
                </button>
              </div>
            </div>
          </div>
        )}
      </>
    );
  }
}
