import { BrowserRouter, Routes, Route, Outlet, Navigate } from 'react-router-dom'
import { AppSidebar } from '@/components/console/app-sidebar'
import { Topbar } from '@/components/console/topbar'
import { RadarDashboard } from '@/components/radar/radar-dashboard'
import { TargetsTable } from '@/components/targets/targets-table'
import { RadarConfigForm } from '@/components/config/radar-config-form'
function Layout() { return <div className="flex min-h-dvh flex-col md:flex-row"><AppSidebar/><div className="flex min-w-0 flex-1 flex-col"><Topbar/><main className="flex-1 p-4 md:p-6"><Outlet/></main></div></div> }
export default function App() { return <BrowserRouter><Routes><Route element={<Layout/>}><Route index element={<RadarDashboard/>}/><Route path="targets" element={<TargetsTable/>}/><Route path="settings" element={<RadarConfigForm/>}/><Route path="*" element={<Navigate to="/" replace/>}/></Route></Routes></BrowserRouter> }
