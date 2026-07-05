import { useState, useEffect } from 'react'

export default function App() {
  const [activeTab, setActiveTab] = useState('dashboard')
  const [farmers, setFarmers] = useState([])
  const [alerts, setAlerts] = useState([])
  const [weather, setWeather] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetch('https://agroalert-backend-pwps.onrender.com/farmers/all')
      .then(r => r.json())
      .then(data => setFarmers(data.farmers || []))
      .catch(() => {})

    fetch('https://agroalert-backend-pwps.onrender.com/alerts/active?village=manathampalayam')
      .then(r => r.json())
      .then(data => setAlerts(data.alerts || []))
      .catch(() => {})

    fetch('https://agroalert-backend-pwps.onrender.com/weather/history?village=manathampalayam')
      .then(r => r.json())
      .then(data => {
        if (data.records && data.records.length > 0) {
          setWeather(data.records[0])
        }
        setLoading(false)
      })
      .catch(() => setLoading(false))
  }, [])

  const sendAlert = () => {
    fetch('https://agroalert-backend-pwps.onrender.com/alerts/check?village=manathampalayam', { method: 'POST' })
      .then(r => r.json())
      .then(data => alert(`✅ ${data.alerts_created} alerts created!`))
      .catch(() => alert('Error!'))
  }

  return (
    <div style={{ fontFamily: 'Arial', minHeight: '100vh', background: '#f5f5f5' }}>

      {/* Header */}
      <div style={{ background: '#2e7d32', padding: '16px 24px', display: 'flex', alignItems: 'center', gap: 12 }}>
        <span style={{ fontSize: 24 }}>🌾</span>
        <h1 style={{ color: 'white', margin: 0, fontSize: 20 }}>AgroAlert Admin Dashboard</h1>
        <span style={{ marginLeft: 'auto', color: '#a5d6a7', fontSize: 13 }}>
          {loading ? '⏳ Loading...' : '✅ Live Data'}
        </span>
      </div>

      {/* Nav */}
      <div style={{ background: 'white', padding: '0 24px', borderBottom: '1px solid #ddd', display: 'flex' }}>
        {['dashboard', 'farmers', 'alerts', 'weather'].map(tab => (
          <button key={tab} onClick={() => setActiveTab(tab)}
            style={{
              padding: '14px 20px', border: 'none', cursor: 'pointer',
              background: activeTab === tab ? '#e8f5e9' : 'white',
              color: activeTab === tab ? '#2e7d32' : '#666',
              borderBottom: activeTab === tab ? '3px solid #2e7d32' : '3px solid transparent',
              fontWeight: activeTab === tab ? 'bold' : 'normal',
            }}>
            {tab === 'dashboard' ? '📊 Dashboard' :
             tab === 'farmers' ? '👨‍🌾 Farmers' :
             tab === 'alerts' ? '🚨 Alerts' : '🌦️ Weather'}
          </button>
        ))}
      </div>

      <div style={{ padding: 24 }}>

        {/* Dashboard */}
        {activeTab === 'dashboard' && (
          <div>
            {/* Metric Cards */}
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 16, marginBottom: 24 }}>
              {[
                { label: 'Total Farmers', value: farmers.length, icon: '👨‍🌾', color: '#2e7d32' },
                { label: 'Active Alerts', value: alerts.length, icon: '🚨', color: '#d32f2f' },
                { label: 'Temperature', value: weather ? `${weather.temperature}°C` : '--', icon: '🌡️', color: '#e65100' },
                { label: 'Rainfall', value: weather ? `${weather.rainfall_mm}mm` : '--', icon: '🌧️', color: '#1565c0' },
              ].map((card, i) => (
                <div key={i} style={{ background: 'white', borderRadius: 12, padding: 20, boxShadow: '0 2px 8px rgba(0,0,0,0.08)' }}>
                  <div style={{ fontSize: 32 }}>{card.icon}</div>
                  <div style={{ fontSize: 28, fontWeight: 'bold', color: card.color }}>{card.value}</div>
                  <div style={{ color: '#666', fontSize: 14 }}>{card.label}</div>
                </div>
              ))}
            </div>

            {/* Weather + Alerts */}
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>

              {/* Weather */}
              <div style={{ background: 'linear-gradient(135deg, #2e7d32, #00796b)', borderRadius: 12, padding: 24, color: 'white' }}>
                <h3 style={{ margin: '0 0 16px' }}>🌦️ Current Weather</h3>
                <p style={{ margin: '0 0 8px' }}>📍 Manathampalayam</p>
                {weather ? (
                  <>
                    <div style={{ fontSize: 48, fontWeight: 'bold' }}>{weather.temperature}°C</div>
                    <div style={{ display: 'flex', gap: 24, marginTop: 16 }}>
                      <span>💧 {weather.humidity}%</span>
                      <span>🌧️ {weather.rainfall_mm}mm</span>
                    </div>
                  </>
                ) : (
                  <div style={{ fontSize: 20 }}>No data yet</div>
                )}
              </div>

              {/* Alerts */}
              <div style={{ background: 'white', borderRadius: 12, padding: 24, boxShadow: '0 2px 8px rgba(0,0,0,0.08)' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
                  <h3 style={{ margin: 0 }}>🚨 Active Alerts</h3>
                  <button onClick={sendAlert}
                    style={{ background: '#d32f2f', color: 'white', border: 'none', borderRadius: 8, padding: '8px 16px', cursor: 'pointer' }}>
                    + Create Alert
                  </button>
                </div>
                {alerts.length === 0 ? (
                  <p style={{ color: '#666' }}>No active alerts</p>
                ) : alerts.map((alert, i) => (
                  <div key={i} style={{ display: 'flex', justifyContent: 'space-between', padding: '10px 0', borderBottom: '1px solid #eee' }}>
                    <div>
                      <div style={{ fontWeight: 'bold' }}>{alert.type}</div>
                      <div style={{ color: '#666', fontSize: 13 }}>{alert.severity}</div>
                    </div>
                    <div style={{ background: alert.severity === 'critical' ? '#ff4444' : '#ff8800', color: 'white', borderRadius: 20, padding: '4px 12px', fontSize: 13 }}>
                      {alert.risk_score}%
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* Farmers */}
        {activeTab === 'farmers' && (
          <div style={{ background: 'white', borderRadius: 12, padding: 24, boxShadow: '0 2px 8px rgba(0,0,0,0.08)' }}>
            <h3 style={{ margin: '0 0 16px' }}>👨‍🌾 Registered Farmers ({farmers.length})</h3>
            {farmers.length === 0 ? (
              <p style={{ color: '#666' }}>No farmers registered yet</p>
            ) : (
              <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                <thead>
                  <tr style={{ background: '#f5f5f5' }}>
                    {['Name', 'Phone', 'Village'].map(h => (
                      <th key={h} style={{ padding: '12px 16px', textAlign: 'left', color: '#666' }}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {farmers.map((farmer, i) => (
                    <tr key={i} style={{ borderBottom: '1px solid #eee' }}>
                      <td style={{ padding: '12px 16px' }}>{farmer.name}</td>
                      <td style={{ padding: '12px 16px' }}>{farmer.phone}</td>
                      <td style={{ padding: '12px 16px' }}>{farmer.village}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        )}

        {/* Alerts */}
        {activeTab === 'alerts' && (
          <div style={{ background: 'white', borderRadius: 12, padding: 24, boxShadow: '0 2px 8px rgba(0,0,0,0.08)' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
              <h3 style={{ margin: 0 }}>🚨 Alert Management</h3>
              <button onClick={sendAlert}
                style={{ background: '#d32f2f', color: 'white', border: 'none', borderRadius: 8, padding: '10px 20px', cursor: 'pointer', fontWeight: 'bold' }}>
                🔔 Check & Create Alerts
              </button>
            </div>
            {alerts.length === 0 ? (
              <p style={{ color: '#666' }}>No active alerts — Click "Check & Create Alerts"!</p>
            ) : alerts.map((alert, i) => (
              <div key={i} style={{ border: '1px solid #eee', borderRadius: 8, padding: 16, marginBottom: 12 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div>
                    <div style={{ fontWeight: 'bold', fontSize: 16 }}>{alert.type} Alert</div>
                    <div style={{ color: '#666', fontSize: 14, marginTop: 4 }}>{alert.message_tamil}</div>
                  </div>
                  <span style={{ background: alert.severity === 'critical' ? '#ff4444' : '#ff8800', color: 'white', padding: '4px 12px', borderRadius: 20, fontSize: 13 }}>
                    {alert.severity}
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Weather */}
        {activeTab === 'weather' && (
          <div style={{ background: 'white', borderRadius: 12, padding: 24, boxShadow: '0 2px 8px rgba(0,0,0,0.08)' }}>
            <h3 style={{ margin: '0 0 16px' }}>🌦️ Weather History</h3>
            {weather ? (
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 16 }}>
                {[
                  { label: 'Temperature', value: `${weather.temperature}°C`, icon: '🌡️' },
                  { label: 'Humidity', value: `${weather.humidity}%`, icon: '💧' },
                  { label: 'Rainfall', value: `${weather.rainfall_mm}mm`, icon: '🌧️' },
                ].map((item, i) => (
                  <div key={i} style={{ background: '#f5f5f5', borderRadius: 12, padding: 20, textAlign: 'center' }}>
                    <div style={{ fontSize: 40 }}>{item.icon}</div>
                    <div style={{ fontSize: 24, fontWeight: 'bold', color: '#2e7d32' }}>{item.value}</div>
                    <div style={{ color: '#666' }}>{item.label}</div>
                  </div>
                ))}
              </div>
            ) : (
              <p style={{ color: '#666' }}>No weather data yet</p>
            )}
          </div>
        )}
      </div>
    </div>
  )
}